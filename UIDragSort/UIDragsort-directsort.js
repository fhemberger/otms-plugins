/**
 * UIDragSort.js - Version 1.0
 *
 * 2008-06-06, Frederic Hemberger
 *
 * This software is licensed under a Creative Commons
 * Attribution-Share Alike 3.0 License. Some rights reserved.
 * http://creativecommons.org/licenses/by-sa/3.0/
 *
 * If you make modifications/improvements to this software,
 * please drop me a note at mail{at}frederic-hemberger{dot}de
 * so I can include it in future releases.
 *
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


// Configuration
var scriptPath = '/cms/PlugIns/UIDragSort';
var sortImg = '<img src="' + scriptPath + '/images/reddotsort.gif" width="12" height="11" border="0" alt="Sort" title="Sort" />';
var saveImg = '<img src="' + scriptPath + '/images/reddotsave.gif" width="12" height="11" border="0" alt="Save" title="Save" />';


// Inits sorting script, display sort reddots
var sorting = false;
$(document).ready(function()
{
	$('.dragsort').html(sortImg);
});


/**
 * Handles jQuery UI dragsort function and RQL requests
 *
 * @param	sortLink		(object) Sort link DOM element
 * @param	sortContainer	(string) ID of DOM element to be sorted
 * @param	rdLinkName		(string) Name of RedDot link element to be sorted
 *
 * @example <a class="dragsort" onclick="dragSort(this, '#dragsort-list', 'lst_dragsort')">Sort</a>
 */
function dragSort(sortLink, sortContainer, rdLinkName)
{
	var pages, pageArray;
	
	sorting = (sorting === true) ? false : true;

	// Sorting started
	if (sorting === true)
	{
		pages = false;
		pageArray = [];

		// Get child GUIDs from link element for sorting
		$.ajax({
			type: "POST",
			async: true,
			url: scriptPath + "/UIDragSort.asp",
			data: "sort=get&linkname=" + jQuery.trim(rdLinkName),
			dataType: "text",
			success: function(msg) {
				if (msg === false) return;
				pageArray = msg.split(',');
			},
			error: function(msg) { alert( "ERROR while sorting: " + msg ); }
		});

		// Only lists with two or more items can be sorted
		if (pageArray.length == 0)
		{
			alert('Nothing to sort');
			sorting = false;
			return;
		} else {
			// Use GUID as element id
			$(sortContainer + '> *').each(function (i) {
				$(this).attr('id', pageArray[i]);
			});

			// Make sortable and update DOM elements
			$(sortContainer).sortable({});
			$(sortContainer + '> *').toggleClass('dragsort-item');
			$(sortLink).html(saveImg);
		}
	}

	// Sorting finished
	if (sorting === false)
	{
		// Get sorting results
		pageArray = $(sortContainer).sortable("toArray");
		pages = pageArray.join(',');

		// Write sorted GUIDs back to link element
		$.ajax({
			type: "POST",
			async: true,
			url: scriptPath + "/UIDragSort.asp",
			data: "sort=set&linkname=" + jQuery.trim(rdLinkName) + "&pages=" + pages,
			dataType: "text",
			error: function(msg) { alert( "ERROR while sorting: " + msg ); }
		});

		// Revert DOM elements
		$(sortContainer + '> *').toggleClass('dragsort-item');
		$(sortLink).html(sortImg);
	}    
}
