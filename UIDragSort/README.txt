UI: DragSort
============

Version: 1.1 (2008-07-20)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de
         Some rights reserved.

UI: DragSort is a user interface enhancement for OTMS allowing to sort lists
or containers via drag & drop in SmartEdit view.

This is third party software. The author is not affiliated in any manner with
RedDot Solutions AG or Open Text Corporation.

If you make modifications/improvements to this software, please drop me a mail,
so I can include it in future releases. Of cause, it would be also interesting
to hear, who uses this software. Feedback is always appreciated!



WHAT'S NEW
==========

There are now two different sorting methods, you have to choose one for your
templates, they are included differently (see "Installation"):

- Direct Sort
  Direct Sort is the sorting introduced in the initial release. It behaves just
  like the Direct Edit feature in OTMS: Click the sort red dot once to
  activate sorting, click the save red dot to save sort order.

- OnLoad
  This new sorting method is activated on page load, the sort order is saved
  directly at rearrangement of elements. Keep in mind, that this feature
  requires more RQL calls and is not recommended for slow servers with lots
  of concurrent SmartEdit users.



INSTALLATION
============

1. Copy the /UIDragSort folder to the /ASP/PlugIns folder of your RedDot CMS
   installation.

2. In your master page template (i.e. the base template containing the <head> tag
   of your HTML), include the following code:

   <!IoRangeRedDotEditOnly>
     <script type="text/javascript" src="PlugIns/UIDragSort/lib/jquery-1.2.6.pack.js"></script>
     <script type="text/javascript" src="PlugIns/UIDragSort/lib/ui.jquery-1.5rc1-dragsort.packed.js"></script>
     <script type="text/javascript" src="PlugIns/UIDragSort/UIDragSort.js"></script>
   <!/IoRangeRedDotEditOnly>

3. Depending on which sorting method you want to use, include the following
   code in each template where drag & drop sorting should be applied:

   Direct Sort
   ===========

   <!IoRangeRedDotEditOnly><a class="dragsort" onclick="dragSort(this, 'ID OF HTML NODE', 'NAME OF ELEMENT')">Sort</a><!/IoRangeRedDotEditOnly>
   
   Example:
   <!IoRangeRedDotEditOnly><a class="dragsort" onclick="dragSort(this, '#dragsort-list', 'lst_dragsort')">Sort</a><!/IoRangeRedDotEditOnly>
   <ul id="dragsort-list">
     <!IoRangeList><li><%lst_dragsort%></li><!/IoRangeList>
   </ul>


   OnLoad
   ======

   <script type="text/javascript">
   $(document).ready(function() {
     $('ID OF HTML NODE').UIDragSort('NAME OF ELEMENT');
     … (if you have multiple lists/containers per template, add sorting initialization here) …
   });
   </script>

   Example:
   <script type="text/javascript">
   $(document).ready(function()
   {
     $('#dragsort-list').UIDragSort('lst_dragsort');
   });
   </script>


Two demo templates are included in the /demo subfolder. Create a new content class in
your RedDot CMS project and choose "Create template from file" to import the template.



VERSION HISTORY
===============

1.1 - Divided sorting function in two different methods: "Direct Sort" and
      "OnLoad" (see "What's new" for details)
    - Fixed a tiny bug, which prevented sorting with just two elements

1.0 - Initial Release



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
