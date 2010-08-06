<%
' IMPORTANT: Only handles ASCII/ANSI XML files
' Because VB can write UTF-16 but can't read it!
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" href="TransferFilenames.css" type="text/css" />
	<title>Transfer RedDot Descriptions</title>
</head>
<body>
<!--#include file="TransferFilenames.RQLFunctions.asp"-->
<%
' Check if user is logged into RedDot
If LOGIN_GUID <> "" Then
	RQLError = ""

	' Get all file names of current language variant
	RQLQuery = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & _
		"<PROJECT><PAGES action=""listnames"" /></PROJECT>" & _
	"</IODATA>"
	RQLResult = SendXML(RQLQuery, RQLError)
	
	' Clean up root element
	RQLResult = Replace( Replace(RQLResult, "<IODATA>" & vbCrLf, ""), "</IODATA>", "")

	' Write XML Output
	Dim fso, RQLFile

	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	path = fso.GetParentFolderName(Request.ServerVariables("PATH_TRANSLATED")) & "\data\"
	If Not fso.FolderExists(path) Then Set newfolder = fso.CreateFolder(path)
	Set RQLFile = fso.CreateTextFile(path & PROJECT_GUID & ".xml", True, False)
	RQLFile.Write(RQLResult)
	RQLFile.Close

	If fso.FileExists(path & PROJECT_GUID & ".xml") Then
		Call showMessage("Filenames of all pages written to " & path & PROJECT_GUID & ".xml - please check the results") 
	Else
		Call showMessage("Error writing file.")
	End If
	
	RQLFile = NULL
	fso = NULL

End If
%>
</body>
</html>
