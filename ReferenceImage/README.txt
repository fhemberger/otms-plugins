ReferenceImage
==============

Version: 1.0 (2000-04-21)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de
         Some rights reserved.

ReferenceImage is a small helper to reference one image instance to another one,
which makes it ideal for image galleries: Editors have only to take care of the
large image, the thumbnail (i.e. referenced image placeholder with custom size)
is created automatically.

This is done with a little AJAX call from the page. In the template code below,
this event is triggered each time the page is opened for editing. If this seems
inappropriate for you (the script being called each time), you can wrap the
JavaScript in a function and add a RedDot to call it.

A more advanced solution: After the first successful call, write some content to
a standard field (function is not included) and check with some lines of ASP if
the field is empty before making the AJAX call.

This is third party software. The author is not affiliated in any manner with
RedDot Solutions AG or Open Text Corporation.

If you make modifications/improvements to this software, please drop me a mail,
so I can include it in future releases. Of cause, it would be also interesting
to hear, who uses this software. Feedback is always appreciated!



INSTALLATION
============

1. Copy the /referenceImage folder to the /ASP/PlugIns folder of your RedDot CMS installation.

2. Include the following code in your template:

   <!IoRangeRedDotEditOnly>
   <script type="text/javascript">
   // Reference Image via RQL
   var xmlHttp = (typeof XMLHttpRequest != 'undefined') ? new XMLHttpRequest() : null; 
   if (!xmlHttp) {try {xmlHttp  = new ActiveXObject("Msxml2.XMLHTTP");} catch(e) {try {xmlHttp  = new ActiveXObject("Microsoft.XMLHTTP");} catch(e) {xmlHttp  = null;}}}
   if (xmlHttp)
   {
     xmlHttp.open('GET', '/cms/PlugIns/referenceImageAjax/referenceImage.asp?source=IMG_SOURCE&dest=IMG_DEST', true);
   	 xmlHttp.onreadystatechange = function (){ if (xmlHttp.readyState == 4) alert(xmlHttp.responseText); };
   	 xmlHttp.send(null);
   }
   </script>
   <!/IoRangeRedDotEditOnly>

3. Adjust the paramters IMG_SOURCE and IMG_DEST to match your image
   placeholders, but without "<% %>" (e.g. img_teaserimage)



LICENSE
=======

This software is licensed under a Creative Commons License:

Attribution-Share Alike 3.0
(http://creativecommons.org/licenses/by-sa/3.0/)

You are free:

    * to Share – to copy, distribute and transmit the work
    * to Remix – to adapt the work

Under the following conditions:

    * Attribution. You must attribute the work in the manner specified by the
      author or licensor (but not in any way that suggests that they endorse
      you or your use of the work).
    * Share Alike. If you alter, transform, or build upon this work, you may
      distribute the resulting work only under the same, similar or a
      compatible license.
    * For any reuse or distribution, you must make clear to others the license
      terms of this work.
    * Any of the above conditions can be waived if you get permission from the
      copyright holder.
    * Nothing in this license impairs or restricts the author's moral rights.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
