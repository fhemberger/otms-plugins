<%
' -------------------------------------------------------------------
' referenceImage.asp - Version 1.0
'
' 2009-04-21, Frederic Hemberger
'
' This software is distributed under the MIT license:
' http://www.opensource.org/licenses/mit-license
' -------------------------------------------------------------------

LOGIN_GUID = Session("LoginGuid")
SESSIONKEY = Session("SessionKey")
PAGE_GUID  = Session("EditPageGuid")

imgSource     = Request.QueryString("source")
imgDest       = Request.QueryString("dest")

If imgSource <> "" And imgDest <> "" Then
	imgSourceGUID = getElementGUID(imgSource)
	imgDestGUID   = getElementGUID(imgDest)
	
	If imgSourceGUID <> "" And imgDestGUID <> "" Then
		Call referenceImage(imgSourceGUID, imgDestGUID)
	End If
End If
	

' -----------------------------------------------------------------------------
' RQL: Reference Image
'
' @param   imgSourceGUID     GUID of source of element
' @param   imgDestGUID       GUID of destination of element
'
Function referenceImage(imgSourceGUID, imgDestGUID)
	RQLString =  "<IODATA loginguid='" & LOGIN_GUID & "' sessionkey='" & SESSIONKEY & "'>" & _
	             "  <CLIPBOARD action=""ReferenceToElement"" guid='" & imgDestGUID & "' type=""element"" descent=""unknown"">" & _
	             "    <ENTRY guid='" & imgSourceGUID & "' type=""element"" descent=""unknown"" />" & _
	             "  </CLIPBOARD>" & _
	             "</IODATA>"
	RQLResult = sendXml(RQLString)
End Function


' -----------------------------------------------------------------------------
' RQL: Get GUID of given content element
'
' @param   elementName     name of element
' @returns GUID of element
'
Function getElementGUID(elementName)
    ' Get all content elements of a page
    RQLString = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & _
           "  <PAGE guid=""" & PAGE_GUID & """><ELEMENTS action=""load"" /></PAGE>" & _
           "</IODATA>"
    RQLResult = sendXml(RQLString)

    ' Parse XML, return element name/GUID
    Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
    xmlDoc.loadXML(RQLResult)
    elementGUID = xmlDoc.SelectSingleNode("//IODATA/PAGE/ELEMENTS/ELEMENT[@eltname='" & elementName & "']").getAttribute("guid")
    xmlDoc = NULL
    getElementGUID = elementGUID
End Function


' -----------------------------------------------------------------------------
' RQL request
'
' @param    XMLString    RQL request
' @return    RQL response
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