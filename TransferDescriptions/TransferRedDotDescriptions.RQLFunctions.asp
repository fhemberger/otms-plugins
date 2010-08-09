<%
' -------------------------------------------------------------------
' Transfer RedDot Descriptions (RQL Functions) - Version 1.0
'
' 2009-12-11, Frederic Hemberger
'
' This software is distributed under the MIT license:
' http://www.opensource.org/licenses/mit-license
' -------------------------------------------------------------------


LOGIN_GUID = Session("LoginGuid")
SESSIONKEY = Session("SessionKey")
PROJECT_GUID  = Session("ProjectGuid")

dim RQLError


' -- RQL helper functions -------------------------------------------
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
