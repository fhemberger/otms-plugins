Transfer Filenames 1.0 (2009-12-11)
======================

by Frederic Hemberger, Some rights reserved.
mail[at]frederic-hemberger[dot]de

Although the CMS already has a function to take over filenames to all language
variants, it is of no use if you want to translate the filenames to match your
SEO strategy. And going through a whole project to set them by hand is a
terrible job.

This plugin allows you to export all filenames of a language variant to an XML
file, translate them and insert them back to another language variant with just
a few clicks.

This is third party software. The author is not affiliated in any manner with
RedDot Solutions AG or Open Text Corporation.

If you make modifications/improvements to this software, please drop me a mail,
so I can include it in future releases. Of cause, it would be also interesting
to hear, who uses this software. Feedback is always appreciated!



INSTALLATION
============

1. Install and activate the plug-in.

2. Make sure that the /data Directory is writeable for the RedDot system user
   (this should normally be the case)



USAGE
=====

The plugin is linked to the page tree's project node in Smart Tree.

1. Select the project's language variant, where you want to export the file
   names (usually your project's main language).

2. Click "Read all file names (current language variant)", this writes an
   XML with the project GUID as filename to the plug-in's data folder
   (usually /ASP/PlugIns/TransferFilenames/data/).

3. You can now translate all filenames

   IMPORTANT: Check the XML file and make sure it doesn't contain illegal
   characters breaking the XML. You can do this for example by opening the
   XML directly in the browser.
   This XML is pushed as an RQL statement back to your server, so be careful!

4. Switch the language variant of your project.

5. Select "Write all file names (current language variant)". 



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
