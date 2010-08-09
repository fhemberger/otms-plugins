<%
' -------------------------------------------------------------------
' Transfer RedDot Descriptions - ReadDescription.asp - Version 1.0
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
	If LOGIN_GUID <> "" Then Call ReadDescriptions
	xmlDoc = NULL


	Sub ReadDescriptions
		RQLError = ""


		' ** STEP 1: Get all content classes ******************************************
		Response.Write "Get all content classes of project ... "

		RQLRequest = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """><TEMPLATES action=""list"" /></IODATA>"
		RQLResult = sendXML(RQLRequest, RQLError)
		If RQLError = "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: " & RQLError & "<br/>" : Exit Sub : End If


		' ** STEP 2: Get all content elements of all content classes ******************
		Response.Write "Get all content elements of all content classes ... "

		' Build RQL request
		RQLRequest = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & vbCrLf
		xmlDoc.loadXML(rqlResult)
		Set RDxmlNodeList = xmlDoc.getElementsByTagName("TEMPLATE") 
		For i = 0 To (RDxmlNodeList.length - 1)
			RQLRequest = RQLRequest & "<PROJECT><TEMPLATE action=""load"" guid=""" & RDxmlNodeList.item(i).getAttribute("guid") & """><ELEMENTS childnodesasattributes=""0"" action=""load""/></TEMPLATE></PROJECT>" & vbCrLf
		Next
		RQLRequest = RQLRequest & "</IODATA>"
		RQLResult = sendXML(RQLRequest, RQLError)
		If RQLError = "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: " & RQLError & "<br/>" : Exit Sub : End If


		' ** STEP 3: Get all elements with a description ******************************
		Response.Write "Get all elements with a description ... "

		xmlDoc.loadXML(rqlResult)
		Set RDxmlNodeList = xmlDoc.selectNodes("//ELEMENT[@eltrddescription!='']")

		descriptionList = "<TEMPLATE><ELEMENTS>" & vbCrLf
		For i = 0 To (RDxmlNodeList.length - 1)
		   descriptionList = descriptionList & "<ELEMENT action=""save"" eltname=""" & RDxmlNodeList.item(i).getAttribute("eltname") & """ eltrddescription=""" & Server.HTMLEncode( RDxmlNodeList.item(i).getAttribute("eltrddescription") ) & """ guid=""" & RDxmlNodeList.item(i).getAttribute("guid") & """ />" & vbCrLf
		Next
		descriptionList = descriptionList & "</ELEMENTS></TEMPLATE>" & vbCrLf
		If RQLError = "" Then Response.Write "OK.<br/>" Else Response.Write "ERROR: " & RQLError & "<br/>" : Exit Sub : End If


		' ** STEP 4: Write XML Output *************************************************
		Response.Write "Write XML Output ... "
		Dim fso, RQLFile

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		path = fso.GetParentFolderName(Request.ServerVariables("PATH_TRANSLATED")) & "\data\"
		If Not fso.FolderExists(path) Then Set newfolder = fso.CreateFolder(path)
		Set RQLFile = fso.CreateTextFile(path & PROJECT_GUID & ".xml", True, False)
		RQLFile.Write(descriptionList)
		RQLFile.Close

		If fso.FileExists(path & PROJECT_GUID & ".xml") Then
			Response.Write PROJECT_GUID & ".xml - please check the results"
		Else
			Response.Write "Error writing file."
		End If
		
		RQLFile = NULL
		fso = NULL
	End Sub
	%>
	</div>
	<div id="footer">
		<button onclick="self.close()"><div class="submit">OK</div></button>
	</div>
</body>
</html>