ReferenceImage
==============

Version: 1.0 (2008-04-21)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de

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



LICENSE (The MIT-License)
=======

Copyright (c) 2008 Frederic Hemberger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
