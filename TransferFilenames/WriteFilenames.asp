<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" href="TransferFilenames.css" type="text/css" />
	<title>Transfer RedDot Descriptions</title>
</head>
<body>
	<div id="response">

	<!--#include file="TransferFilenames.RQLFunctions.asp"-->
	<%
	' Check if user is logged into RedDot
	If LOGIN_GUID <> "" Then
		RQLError = ""
		errorThrown = FALSE

		' ** STEP 1: Load File ********************************************************
		Response.Write "Loading description file (" & PROJECT_GUID & ".xml) ... "
		Dim fso, RQLFile

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		path = fso.GetParentFolderName(Request.ServerVariables("PATH_TRANSLATED")) & "\data\"

		If fso.FileExists(path & PROJECT_GUID & ".xml") Then
			Set RQLFile = fso.OpenTextFile(path & PROJECT_GUID & ".xml", 1, -1)
			RQLInnerRequest = RQLFile.ReadAll
			If RQLInnerRequest <> "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: Could not read file.<br/>" : errorThrown = TRUE : End If
			RQLFile = NULL
			fso = NULL
		Else
			Response.Write "ERROR: File not found. This file has to be created with 'Read Filenames' first.<br/>"
			errorThrown = TRUE
		End If

		' ** STEP 2: Check if data is readable XML (does NOT check for valid RQL!) ****
		If errorThrown = FALSE Then
			Response.Write "Checking XML data ... "

			Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
			xmlDoc.loadXML(RQLInnerRequest)
			If xmlDoc.parseError.errorCode = 0 Then Response.Write "OK.<br/>" Else Response.Write "ERROR: Invalid XML<br/>" : errorThrown = TRUE : End If
		End If

		' Clean up root element
		RQLInnerRequest = Replace( Replace(RQLInnerRequest, "<PAGES>" & vbCrLf, ""), "</PAGES>", "")

		' Add save parameter
		RQLInnerRequest = Replace(RQLInnerRequest, "<PAGE ", "<PAGE action=""save"" ")
		
		' ** STEP 3: Writing descriptions to current language variant *****************
		If errorThrown = FALSE Then
			Response.Write "Writing file names to current language variant ... "

			' Build RQL request
			RQLRequest = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & RQLInnerRequest & "</IODATA>"
			RQLResult = sendXML(RQLRequest, RQLError)
			If RQLError = "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: " & RQLError & "<br/>" : errorThrown = TRUE : End If
		End If
		xmlDoc = NULL
	End If
	%>
	</div>
	<div id="footer">
		<button onclick="self.close()"><div class="close">Close</div></button>
	</div>
</body>
</html>
