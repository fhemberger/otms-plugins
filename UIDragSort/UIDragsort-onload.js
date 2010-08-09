/**
 * UIDragSort.js - Version 1.1
 *
 * 2008-07-20, Frederic Hemberger
 *
 * This software is distributed under the MIT license:
 * http://www.opensource.org/licenses/mit-license
 */

var scriptPath = '/cms/PlugIns/UIDragSort';

/**
 * Handles jQuery UI dragsort function and RQL requests
 *
 * @param    rdElement    (string) Name of RedDot element to be sorted
 * @extends  jQuery
 *
 * @example  $('#dragsort-list').UIDragSort('lst_dragsort');
 */
jQuery.fn.UIDragSort = function(rdElement) {
	var pages = false, pageArray = [];

	// Get child GUIDs from link element for sorting
	$.ajax({
		type: "POST",
		async: true,
		url: scriptPath + "/UIDragSort.asp",
		data: "sort=get&linkname=" + $.trim(rdElement),
		dataType: "text",
		success: function(msg) {
			if (msg === false) return;
			pageArray = msg.split(',');
		},
		error: function(msg) { alert( "ERROR while sorting: " + msg ); return false; }
	});	

	// Only lists with two or more items can be sorted
	if (pageArray.length == 0) { alert('Nothing to sort'); return false; }

	// Use GUID as element id
	$('> *', this).each(function (i) {
		$(this).attr('id', pageArray[i]);
	});

	// Make sortable and update DOM elements
	this.sortable({
		update: function(e, ui)
		{
			// Get sorting results
			var pageArray = $(this).sortable("toArray");
			var pages = pageArray.join(',');

			// Write sorted GUIDs back to link element
			$.ajax({
				type: "POST",
				async: true,
				url: scriptPath + "/UIDragSort.asp",
				data: "sort=set&linkname=" + $.trim(rdElement) + "&pages=" + pages,
				dataType: "text",
				error: function(msg) { alert( "ERROR while sorting: " + msg ); }
			});
		}
	});
	$('> *', this).toggleClass('dragsort-item');
	return true;
};