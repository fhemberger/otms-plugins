<%
' -------------------------------------------------------------------
' Transfer RedDot Descriptions - WriteDescription.asp - Version 1.0
'
' 2009-12-11, Frederic Hemberger
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
	<link rel="stylesheet" href="RDDialog.css" type="text/css" />
	<!--<![if lt IE 7]>
	<style type="text/css">
	div#footer {
		bottom: auto;
		top: expression( ( -10 - footer.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
	}
	</style>
	<![endif]-->
	<title>Transfer RedDot Descriptions</title>
</head>
<body>
	<div id="response">
	<!--#include file="TransferRedDotDescriptions.RQLFunctions.asp"-->
	<%
	Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
	' Only start if called from RedDot
	Call WriteDescriptions
	xmlDoc = NULL


	Sub WriteDescriptions
		RQLError = ""


		' ** STEP 1: Load File ********************************************************
		Response.Write "Loading description file (" & PROJECT_GUID & ".xml) ... "
		Dim fso, RQLFile

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		path = fso.GetParentFolderName(Request.ServerVariables("PATH_TRANSLATED")) & "\data\"

		If fso.FileExists(path & PROJECT_GUID & ".xml") Then
			Set RQLFile = fso.OpenTextFile(path & PROJECT_GUID & ".xml", 1, -1)
			RQLInnerRequest = RQLFile.ReadAll
			If RQLInnerRequest <> "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: Could not read file.<br/>" : Exit Sub : End If
			RQLFile = NULL
			fso = NULL
		Else
			Response.Write "ERROR: File not found. This file has to be created with 'Read Descriptions' first.<br/>"
			Exit Sub
		End If


		' ** STEP 2: Check if data is readable XML (does NOT check for valid RQL!) ****
		Response.Write "Checking XML data ... "
		xmlDoc.loadXML(RQLInnerRequest)
		If xmlDoc.parseError.errorCode = 0 Then Response.Write "OK.<br/>" Else Response.Write "ERROR: Invalid XML<br/>" : Exit Sub : End If


		' ** STEP 3: Writing descriptions to current language variant *****************
		Response.Write "Writing descriptions to current language variant ... "

		' Build RQL request
		RQLRequest = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & RQLInnerRequest & "</IODATA>"
		RQLResult = sendXML(RQLRequest, RQLError)
		If RQLError = "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: " & RQLError & "<br/>" : Exit Sub : End If
	End Sub
	%>
	</div>
	<div id="footer">
		<button onclick="self.close()"><div class="submit">OK</div></button>
	</div>
</body>
</html>