<%
' -------------------------------------------------------------------
' UIDragSort.asp - Version 1.1
'
' 2008-07-20, Frederic Hemberger
'
' This software is licensed under a Creative Commons
' Attribution-Share Alike 3.0 License. Some rights reserved.
' http://creativecommons.org/licenses/by-sa/3.0/
'
' If you make modifications/improvements to this software,
' please drop me a note at mail[at]frederic-hemberger[dot]de
' so I can include it in future releases.
'
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
' OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
' OTHER DEALINGS IN THE SOFTWARE.
' -------------------------------------------------------------------


LOGIN_GUID = session("LoginGuid")
SESSIONKEY = session("SessionKey")
PAGE_GUID  = session("EditPageGuid")


' We won't start with crappy data ...
If isValidGuid(LOGIN_GUID) AND isValidGuid(SESSIONKEY) AND isValidGuid(PAGE_GUID) Then
	' Check linkname, pages are checked in setLinkSorting()
	reqLinkname = stripHTML(request("linkname"))
	Select Case request("sort")
	    Case "get"
			response.write getLinkSorting(reqLinkname)
		Case "set"
			response.write setLinkSorting(reqLinkname, request("pages"))
	End Select
End If


' Check for valid GUIDs: RedDot GUIDs are 32 chars long hexadecimal values
'
' @param	guid
' @return	Boolean
'
Function isValidGuid(guid)
	Set objRegExp = new RegExp
	objRegExp.Pattern = "^[A-F0-9]{32}$"
	isValidGuid = objRegExp.Test(guid)
	Set objRegExp = nothing
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
  objRegExp.Pattern = "</?(.*)>"

  'Replace all HTML tag matches with the empty string
  strOutput = objRegExp.Replace(strHTML, "")
  
  stripHTML = strOutput
  Set objRegExp = Nothing
End Function


' Returns list of link elements
'
' @param	linkName	Name of link element (i.e. container or list)
' @return	comma seperated string of page GUIDs or false (if there is nothing to sort)
'
' @example	getLinkSorting("lst_content")
'
Function getLinkSorting(linkName)
	Dim linkGuid, rqlQuery, rqlResult, pages
	
	linkGuid = getLinkGuid(PAGE_GUID, linkName)
	
	rqlQuery = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & _
	               "<LINK action=""load"" guid=""" & linkGuid & """><PAGES action=""list""/></LINK>" & _
	           "</IODATA>"

	rqlResult = sendXML(rqlQuery) 
	Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
	xmlDoc.loadXML(rqlResult)
	Set RDxmlNodeList = xmlDoc.getElementsByTagName("PAGE") 

	' Only return sorting values if there is something to sort (i.e. two elements or more)
	If RDxmlNodeList.length > 1 Then
		pages = ""
		For i = 0 To (RDxmlNodeList.length - 1)
			pages = pages & RDxmlNodeList.item(i).getAttribute("guid") & ","
		Next
		pages = Left(pages, Len(pages) - 1)
		set RDxmlNodeList = nothing
		set xmlDoc = nothing
		getLinkSorting = pages
	Else
		getLinkSorting = false
	End If
End Function


' Writes sorting of elements to given link element
'
' @param	linkName	Name of link element (i.e. container or list)
' @param	pages		comma seperated string of page GUIDs
'
Function setLinkSorting(linkName, pages)
	Dim linkGuid, pageArray, pageList, rqlQuery, rqlResult
	
	linkGuid = getLinkGuid(PAGE_GUID, linkName)

	pageArray = Split(pages, ",")
	pageList = ""
	For i = 0 To (UBound(pageArray))
		If isValidGuid(pageArray(i)) Then pageList = pageList & "<PAGE guid=""" & pageArray(i) & """ />"
	Next
	
	rqlQuery = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & _
	               "<LINK action=""save"" guid=""" & linkGuid & """ orderby=""5""><PAGES action=""saveorder"">" & pageList & "</PAGES></LINK>" & _
	           "</IODATA>"
	rqlResult = sendXML(rqlQuery) 
	setLinkSorting = rqlResult
End Function


' -- RQL helper functions -------------------------------------------

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


' Returns the GUID of given element name in current page
'
' @param	pageGuid	GUID of page to search
' @param	linkName	Name of link element (i.e. container or list)
' @return	GUID of element
'
Function getLinkGuid(pageGuid, linkName)
	Dim rqlQuery, rqlResult, tmpGuid
	
	rqlQuery = "<IODATA loginguid=""" & LOGIN_GUID & """ sessionkey=""" & SESSIONKEY & """>" & _
	             "<PAGE guid=""" & pageGuid & """ ><LINKS action=""load"" /></PAGE>" & _
	           "</IODATA>"

	rqlResult = sendXML(rqlQuery) 
	Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
	xmlDoc.loadXML(rqlResult)
	Set RDxmlNodeList = xmlDoc.getElementsByTagName("LINK") 
	
	tmpGuid = 0
	For i = 0 To (RDxmlNodeList.length - 1)
		If RDxmlNodeList.item(i).getAttribute("eltname") = linkName Then
			tmpGuid = RDxmlNodeList.item(i).getAttribute("guid")
			Exit for
		End If	
	Next
	set xmlDoc = nothing
	getLinkGuid = tmpGuid
End Function
%>