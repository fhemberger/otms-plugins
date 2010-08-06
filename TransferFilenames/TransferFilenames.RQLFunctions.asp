<%
LOGIN_GUID = Session("LoginGuid")
SESSIONKEY = Session("SessionKey")
PROJECT_GUID  = Session("ProjectGuid")

Const UTF8_BOM = "ï»¿"
Const UTF16_BOM = "ÿþ<"
dim RQLError


' -- RQL helper functions -------------------------------------------
' Shows Result
'
Sub showMessage(message)
%>
	<div id="response"><b><%=message%></b></div>
	<div id="footer">
		<button onclick="self.close()"><div class="close">Close</div></button>
	</div>
<%
End Sub


' RQL request
'
' @param	XMLString	RQL request
' @return	RQL response
'
Function sendXML(XMLString, ByRef RQLError)
    Set objData = server.CreateObject("RDCMSASP.RdPageData")
    objData.XmlServerClassName="RDCMSServer.XmlServer"
    sendXML = objData.ServerExecuteXml(XMLString, rqlError)
    objData = NULL
End Function
%>
