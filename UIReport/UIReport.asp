<%
' -------------------------------------------------------------------
' UIReport.asp - Version 1.01
'
' 2008-12-30, Frederic Hemberger
'
' This software is distributed under the MIT license:
' http://www.opensource.org/licenses/mit-license
' -------------------------------------------------------------------


' -- Configuration --------------------------------------------------
' Recipient
EMAIL_TO = "reddot-admin@yourcompany.com"

' From address, will be replaced by user's email (if available)
EMAIL_FROM_FALLBACK = "noreply@yourcompany.com"
' -------------------------------------------------------------------
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" href="UIReport.css" type="text/css" />
	<title>Report</title>
</head>
<body>

<%
' Check if user is logged into RedDot
If Session("LoginGuid") <> "" Then
	If Request.Form("report") <> "" Then

		userName = Session("UserFullName")
		' Fallback email if no user email is available
		If userName = "" Then userName = Session("UserName")
		
		userEmail = getUserEmail()
		' Fallback email if no user email is available
		If userEmail = "" Then userEmail = EMAIL_FROM_FALLBACK

		emailSubject = "[RedDot UI: Report] Error report " & Session("Project") & ": " & Session("PageHeadline") & " (ID: " & Session("PageId") & ")"
		
		pageStatus = ""
		If Session("fWaitingForRelease") = True Then pageStatus = "Waiting For Release"
		If Session("fReleased")          = True Then pageStatus = "Released"
		If Session("fUnlinkedPage")      = True Then pageStatus = "Unlinked"
		
		isNavMan = ""
		If Session("fNavigationManager") = True Then isNavMan = "(Navigation Manager)"
		
		emailBody = "" & _
			"Date: " & Date() & " " & Time() & vbCrLf & vbCrLf & _
			"Report" & vbCrLf & _
			"======" & vbCrLf & _
			stripHTML(Request.Form("report")) & vbCrLf & _
			vbCrLf & _
			
			"User Information" & vbCrLf & _
			"================" & vbCrLf & _
			"User name:  " & Session("UserName") & " (" & Session("UserFullName") & ")" & vbCrLf & _
			"User level: " & Session("UserLevel") & vbCrLf & _
			"User agent: " & Session("UserAgent") & vbCrLf & _
			vbCrLf & _

			"Page Information" & vbCrLf & _
			"================" & vbCrLf & _
			"Project:   " & Session("Project") & " " & isNavMan & vbCrLf & _
			"Page:      " & Session("PageHeadline") & " (ID: " & Session("PageId") & ")" & vbCrLf & _
			"Status:    " & pageStatus & vbCrLf & _
			"Language:  " & Session("CurrentLanguageName") & " (" & Session("LanguageVariantId") & ")" & vbCrLf & _
			"Template:  " & Session("Template") & vbCrLf

		On Error Resume Next

		' Try to send email
		Set objEmail      = CreateObject("CDO.Message")
		objEmail.From     = userName & "<" & userEmail & ">"
		objEmail.To       = EMAIL_TO
		objEmail.Subject  = emailSubject 
		objEmail.Textbody = emailBody
		objEmail.Send
		Set objEmail = nothing

		If Err.Number > 0 Then
			' If it doesn't work (e.g. no SMTP server), let us know.
			showStatusMessage("Could not send report. Check the mail settings in the Server Manager.")

			' Note: If you don't have a SMTP server connection, you can also send mails via RQL.
			' Check the RQL documentation for the proper statement.'
		    Err.Clear
		Else
		    ' Dude, everything went smooth!
			showStatusMessage("Report sent successfully.")
		End If
		
		On Error GoTo 0
	Else
		showReportForm()
	End If	
End If


' Shows Report Form
'
Function showReportForm()
%>
	<form action="UIReport.asp" name="reportForm" method="post">
		<label for="report">Enter Report</label>
		<textarea name="report" id="report"></textarea>
	</form>
	<div id="footer">
		<button onclick="self.close()"><div class="cancel">Cancel</div></button>
		<button onclick="document.reportForm.submit()"><div class="submit">Submit</div></button>
	</div>

	
<%
End Function


' Shows Status Message
'
Function showStatusMessage(message)
%>
	<div id="response"><b><%=message%></b></div>
	<div id="footer">
		<button onclick="self.close()"><div class="close">Close</div></button>
	</div>
<%
End Function


' Strips the HTML tags from strHTML
'
' @param	strHTML		String containing HTML
' @return	String
'
Function stripHTML(strHTML)
  Dim strOutput

  Set objRegExp = New Regexp
  objRegExp.IgnoreCase = True
  objRegExp.Global = True
  'objRegExp.Pattern = "</?(.*)>"
  objRegExp.Pattern = "<\/?(.[^<^>]*)>"

  'Replace all HTML tag matches with the empty string
  strOutput = objRegExp.Replace(strHTML, "")
  
  stripHTML = strOutput
  Set objRegExp = Nothing
End Function


' Fetch user email
'
' @return	Email address
'
Function getUserEmail()
	rqlQuery   = "<IODATA loginguid=""" & Session("LoginGuid") & """><ADMINISTRATION><USER action=""load"" guid=""" & Session("UserGuid") & """ /></ADMINISTRATION></IODATA>"
	rqlResult  = sendXML(rqlQuery)
	Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
	xmlDoc.loadXML(rqlResult)
	getUserEmail = xmlDoc.SelectSingleNode("//IODATA/USER").getAttribute("email")
End Function


' RQL request
'
' @param	XMLString	RQL request
' @return	RQL response
'
Function sendXML(XMLString)
	Set objData = server.CreateObject("RDCMSASP.RdPageData")
	objData.XmlServerClassName="RDCMSServer.XmlServer"
	sendXML = objData.ServerExecuteXml(XMLString, sErrors)
	If sErrors <> "" Then
		response.write "Errors occured: " & sErrors & chr(13)
	End If
	objData = NULL
End Function
%>
</body>
</html>
