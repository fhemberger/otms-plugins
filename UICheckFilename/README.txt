UI: Check Filename
==================

Version: 1.1 (2009-12-10)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de
         Some rights reserved.

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



LICENSE
=======

This software is licensed under a Creative Commons License:

Attribution-Share Alike 3.0
(http://creativecommons.org/licenses/by-sa/3.0/)

You are free:

    * to Share — to copy, distribute and transmit the work
    * to Remix — to adapt the work

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
