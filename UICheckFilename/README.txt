UI: Check Filename
==================

Version: 1.1 (2009-12-10)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de

UI: Check Filename is an user interface enhancement for OTMS. It checks if the
file name for the current page is already used for another page to prevent one
file being overwritten by another one if published to the same folder.

With Version 1.1, there are two different operation modes: A HTML popup (default)
and a direct text output for AJAX calls. Additionally, you can also check if the
given file name is valid (contains only chars, numbers, hyphens, underscores and
periods) Ð no spaces, umlauts or other characters a web server might have problems
with.

This is third party software. The author is not affiliated in any manner with
RedDot Solutions AG or Open Text Corporation.

If you make modifications/improvements to this software, please drop me a mail,
so I can include it in future releases. Of cause, it would be also interesting
to hear, who uses this software. Feedback is always appreciated!



INSTALLATION
============

1. Copy the /UICheckFilename folder to the /ASP/PlugIns folder of your OT CMS installation.

2. Include the following code in your template to enable reporting:

   -- For the default HTML popup --
   <!IoRangeRedDotEditOnly>
   <a href="#" onclick="window.open('PlugIns/UICheckFilename/UICheckFilename.asp', 'UICheckFilename', 'width=650,height=550');void(0);">
      Check file name
   </a>
   <!/IoRangeRedDotEditOnly>


   -- for the direct text output --
   <!IoRangeRedDotEditOnly>
   <script type="text/javascript">
     /* <![CDATA[ */
     // Requires IE7 or newer, http://en.wikipedia.org/wiki/XMLHttpRequest contains fallback for older browsers
     xmlhttp = new XMLHttpRequest();
     xmlhttp.open("GET", "PlugIns/UICheckFilename/UICheckFilename.asp?ajax=true", true);
     xmlhttp.onreadystatechange = function() { if (xmlhttp.readyState===4) { alert(xmlhttp.responseText); }}
     xmlhttp.send(null);
     /* ]]> */
   </script>
   <!/IoRangeRedDotEditOnly>

3. If you also want to check you filename vor validity, add "validate=true" to the request, e.g.

   UICheckFilename.asp?validate=true Ñ or Ñ

   UICheckFilename.asp?ajax=true&amp;validate=true



VERSION HISTORY
===============

1.1 - Added AJAX support and validation

1.0 - Initial Release



LICENSE (The MIT-License)
=======

Copyright (c) 2009 Frederic Hemberger

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
