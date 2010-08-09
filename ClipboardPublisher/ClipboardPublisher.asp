<%
' -------------------------------------------------------------------
' ClipboardPublisher.asp - Version 1.02
'
' 2008-08-11, Frederic Hemberger
'
' This software is distributed under the MIT license:
' http://www.opensource.org/licenses/mit-license
' -------------------------------------------------------------------
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="pragma" content="no-cache" />
	<link rel="stylesheet" href="ClipboardPublisher.css" type="text/css" />
	<script type="text/javascript" src="ClipboardPublisher.js"></script>
	<title>ClipboardPublisher</title>
</head>
<body>
<%
dim rqlError

' Check if user is logged into RedDot
If Session("LoginGuid") <> "" Then
	' Get selected pages from clipboard
	selectedGUIDs = Split(getSelectedPageGUIDs, vbCrLf)
	If UBound(selectedGUIDs) > -1 Then
		' Check publishing settings
		If Request.Form("GUIDs") <> "" Then
			Call publishSelectedPages()
		Else
			Call showPublishForm(selectedGUIDs)
		End If
	Else	
	%>
		<div id="response"><b>No pages selected in clipboard.</b></div>
		<div id="footer">
			<button onclick="self.close()"><div class="close">Close</div></button>
		</div>
	<%
	End If
End If	



' Parses all data provided by the publishing form and sends the RQL request
' On success, the plug-in window is closed, otherwise the RQL error code is shown.
'
Sub publishSelectedPages()
	Dim arrGUIDs, arrLng, arrPrj, followup, related, lngVariants, prjVariants
	Dim rqlQuery, rqlResult, rqlError, tmpError
	
	' Get form fields and build publishing RQL string
	arrGUIDs = Split(Request.Form("GUIDs"))
	arrLng = Split(Trim(Replace(Request.Form("lng"), ",", "")))
	arrPrj = Split(Trim(Replace(Request.Form("prj"), ",", "")))

	followup = 0 : If Request.Form("followup") = 1 Then followup = 1
	related = 0 : If Request.Form("related") = 1 Then related = 1

	lngVariants = ""
	For lng = 0 To UBound(arrLng)
		lngVariants = lngVariants & "<LANGUAGEVARIANT guid=""" & arrLng(lng) & """ checked=""1""/>"
	Next

	prjVariants = ""
	For prj = 0 To UBound(arrPrj)
		prjVariants = prjVariants & "<PROJECTVARIANT guid=""" & arrPrj(prj) & """ checked=""1""/>"
	Next

	rqlQuery = "<IODATA><PROJECT guid=""" & session("ProjectGuid") & """ sessionkey=""" & session("Sessionkey") & """>"
	For page = 0 To UBound(arrGUIDs)
	rqlQuery = rqlQuery & "<PAGE guid=""" & arrGUIDs(page) & """>" & _
                       "<EXPORTJOB action=""save"" email=""" & Request.Form("user") & """ toppriority=""0"" generatenextpages=""" & followup & """ generaterelativepages=""" & related & """ reddotserver="""" application="""" generatedate=""0"" startgenerationat=""0"">" & _
                           "<LANGUAGEVARIANTS action=""checkassigning"">" & lngVariants & "</LANGUAGEVARIANTS>" & _
                           "<PROJECTVARIANTS action=""checkassigning"">" & prjVariants & "</PROJECTVARIANTS>" & _
                "</EXPORTJOB></PAGE>"
	Next
	rqlQuery = rqlQuery & "</PROJECT></IODATA>"
	rqlResult = sendXML(rqlQuery, rqlError)
	
	If rqlError <> "" Then
		' Just display the first error message.
		tmpError = Split(rqlError, vbCrLf)
		if UBound (tmpError) > -1 Then rqlError = tmpError(0)
		%>
			<div id="response"><b><%=rqlError%></b></div>
			<div id="footer">
				<button onclick="self.close()"><div class="close">Close</div></button>
			</div>
		<%
	Else
		%><script type="text/javascript">self.close()</script><%
	End If
End Sub



' Shows the publishing form similar to RedDot's "Publish Page" dialog
'
' @return	GUIDs separated by vbCrLf or empty string on error
'
Sub showPublishForm(selectedGUIDs)
	Dim rqlQuery, rqlResult, i, guid, text
	
	' Get language and project variants for the current project
	rqlQuery = "<IODATA loginguid=""" & session("LoginGuid") & """ sessionkey=""" & session("Sessionkey") & """>" & _
	               "<PROJECT><EXPORTJOB>" & _
	                   "<LANGUAGEVARIANTS action=""listall"" includerights=""1""/>" & _
	                   "<PROJECTVARIANTS action=""listall"" includerights=""1""/>" & _
	               "</EXPORTJOB></PROJECT>" & _
	           "</IODATA>"
	rqlResult = sendXML(rqlQuery, rqlError)

	Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
	xmlDoc.loadXML(rqlResult)
	%>

	<form action="ClipboardPublisher.asp" name="publishForm" method="post">
		<input type="hidden" name="GUIDs" value="<%=Trim(Join(selectedGUIDs))%>" />
		<input type="hidden" name="user" value="<%=session("UserGuid")%>" />
		<h2>Publish <%=UBound(selectedGUIDs)%> pages from clipboard</h2>

		<input type="checkbox" name="followup" value="1" id="followup" /><label for="followup">Publish all following pages</label><br />
		<input type="checkbox" name="related" value="1" id="related" /><label for="related">Publish related pages</label>
		<fieldset>
			<legend>Language variants available for publication:</legend>

			<%
			Set RDxmlNodeList = xmlDoc.getElementsByTagName("LANGUAGEVARIANT") 
			For i = 0 To (RDxmlNodeList.length - 1)
				guid = RDxmlNodeList.item(i).getAttribute("guid")
				lang = RDxmlNodeList.item(i).getAttribute("language")
				name = RDxmlNodeList.item(i).getAttribute("name")
				%><input type="checkbox" name="lng" value="<%=guid%>" id="lng-<%=guid%>" <% If guid = Session("CurrentLanguageGuid") Then %>checked="checked" <% End If %>/><label for="lng-<%=guid%>" class="language-variant"><%=name%> (<%=lang%>) </label><br /><%
			Next
			%>
		</fieldset>

		<fieldset>
			<legend>Project variants available for publication:</legend>
			<%
			Set RDxmlNodeList = xmlDoc.getElementsByTagName("PROJECTVARIANT") 
			For i = 0 To (RDxmlNodeList.length - 1)
				guid = RDxmlNodeList.item(i).getAttribute("guid")
				text = RDxmlNodeList.item(i).getAttribute("name")
				%><input type="checkbox" name="prj" value="<%=guid%>" id="prj-<%=guid%>" <% If i = 0 Then %>checked="checked" <% End If %>/><label for="prj-<%=guid%>" class="project-variant"><%=text%></label><br /><%
			Next
			%>
		</fieldset>
	</form>
	<div id="footer">
		<button onclick="checkPublishForm();"><div class="submit">OK</div></button>
		<button onclick="self.close()"><div class="cancel">Cancel</div></button>
	</div>
	<%
	set RDxmlNodeList = nothing
	set xmlDoc = nothing
End Sub



' Returns the GUIDs of selected pages in the clipboard
'
' @return	GUIDs separated by vbCrLf or empty string on error
'
Function getSelectedPageGUIDs()
	Dim rqlQuery, rqlResult, filteredHTML, strGUIDs
	
	' Get RedDot clipboard content
	rqlQuery = "<IODATA loginguid=""" & session("LoginGuid") & """>" & _
	               "<ADMINISTRATION><USER guid=""" & session("UserGuid") & """><CLIPBOARDDATA action=""load"" projectguid=""" & session("ProjectGuid") & """/></USER></ADMINISTRATION>" & _
	           "</IODATA>"
	rqlResult = sendXML(rqlQuery, rqlError)

	If Len(rqlResult) > 0 Then
		Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
		xmlDoc.loadXML(rqlResult) 
		clipboardContent = unescape(xmlDoc.SelectSingleNode("//IODATA/CLIPBOARDDATA").getAttribute("value"))
		clipboardContent = Replace(clipboardContent, vbCrLf, "")
		Set xmlDoc = nothing
		
		' We have to filter the content, as it is ugly HTML 3.2
		filteredHTML = ""

		Set objRegExpInput = new RegExp
		objRegExpInput.Pattern = "<TR (.*?)>(.*?)<INPUT(.*?)></TD>"
		objRegExpInput.Global = True
		Set htmlSnippets = objRegExpInput.Execute(clipboardContent)
		For Each htmlSnippet In htmlSnippets
			' Combine all selected entries which are pages into the string for further processing
		    If ( InStr(htmlSnippet.Value, "CHECKED") > 0 AND InStr(htmlSnippet.Value, "elttype=""page""") > 0 ) Then filteredHTML = filteredHTML & htmlSnippet.Value
		Next
		
		' Now we have the selected pages, let's get the GUIDs
		strGUIDs = ""
		objRegExpInput.Pattern = "id=[A-F0-9]{32}"
		objRegExpInput.Global = True
		Set pageGUIDs = objRegExpInput.Execute(filteredHTML)
		For Each pageGUID In pageGUIDs
			strGUIDs = strGUIDs & Right(pageGUID.Value, 32) & vbCrLf
		Next
		Set objRegExpInput = nothing
		
		getSelectedPageGUIDs = strGUIDs
	Else
		getSelectedPageGUIDs = ""
	End If	
End Function


' -- RQL helper functions -------------------------------------------
' RQL request
'
' @param	XMLString	RQL request
' @return	RQL response
'
Function sendXML(XMLString, ByRef rqlError)
    Set objData = server.CreateObject("RDCMSASP.RdPageData")
    objData.XmlServerClassName="RDCMSServer.XmlServer"
    sendXML = objData.ServerExecuteXml(XMLString, rqlError)
    objData = NULL
End Function
%>
</body>
</html>