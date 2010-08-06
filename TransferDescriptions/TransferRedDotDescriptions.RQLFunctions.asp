<%
' -------------------------------------------------------------------
' Transfer RedDot Descriptions (RQL Functions) - Version 1.0
'
' 2009-12-11, Frederic Hemberger
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
