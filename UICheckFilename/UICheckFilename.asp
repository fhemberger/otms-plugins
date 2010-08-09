<%
' -------------------------------------------------------------------
' UICheckFilename.asp - Version 1.1
'
' 2009-12-10, Frederic Hemberger
'
' This software is distributed under the MIT license:
' http://www.opensource.org/licenses/mit-license
' -------------------------------------------------------------------
%>

<%
' Init output method (default: HTML)
isAjax = false
lineBreak = "<br />"

If LCase(Request.QueryString("ajax")) = "true" Then
	isAjax = true
	lineBreak = vbCrLf
End If

' Check if user is logged into RedDot
If Session("LoginGuid") <> "" Then
	returnMessage = ""

	' Get current page info
	If Session("PageName") <> "" Then
		' Get all file names of current language variant
		RQLQuery = "<IODATA loginguid=""" & Session("LoginGuid") & """ sessionkey=""" & Session("SessionKey") & """>" & _
			"<PROJECT><PAGES action=""listnames"" /></PROJECT>" & _
	    "</IODATA>"
		RQLResult = SendXML(RQLQuery)

		' Count nodes with filenames of current page
		Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
		xmlDoc.loadXML(RQLResult)
		Set objNodeList = xmlDoc.documentElement.selectNodes("//IODATA/PAGES/PAGE[@name='" & Session("PageName") & "']")
		If objNodeList.length > 1 Then
			returnMessage = "File name already exists!"
		Else
			returnMessage = "File name is unique."
		End If

		' Check if filename is valid (optional)
		If LCase(Request.QueryString("validate")) = "true" Then
			Set objRegExp = new RegExp
			objRegExp.Pattern = "^[a-zA-Z0-9_-.]$"
			objRegExp.Global = True
			isValidName = objRegExp.Test(Session("PageName"))
			Set objRegExp = nothing
			
			If isValidName = true Then
				returnMessage = returnMessage & lineBreak & "File name is valid."
			Else
				returnMessage = returnMessage & lineBreak & "File name contains illegal characters! A file name for the web should only consist of letters, numbers, minus and underscores and should not contain spaces or special characters (e.g. umlauts)."
			End If
		End If
		
		xmlDoc = NULL
		objNodeList = NULL
	Else
		returnMessage = "No file name set for this page."
	End If
Else
	returnMessage = "Script has to be called from RedDot CMS."
End If
Call showMessage(returnMessage, isAjax)



' Shows Result
'
' @param    message    Result of filename check
' @param	isAjax     Boolean: 'false' returns HTML, 'true' returns plain text result
Sub showMessage(message, isAjax)
	If isAjax = True Then
		%>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<head>
			<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
			<link rel="stylesheet" href="UICheckFilename.css" type="text/css" />
			<title>Check Filename</title>
		</head>
		<body>
			<div id="response"><b><%=message%></b></div>
			<div id="footer">
				<button onclick="self.close()"><div class="close">Close</div></button>
			</div>
		</body>
		</html>
		<%
	Else
		Resopnse.Write message
	End If
End Sub


' RQL request
'
' @param    XMLString    RQL request
' @return   RQL response
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