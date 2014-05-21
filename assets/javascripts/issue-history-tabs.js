/*
Author: Daniel Munn <https://github.com/danmunn
Date: 23/05/2012
Forked & Redone: Mark Kalender (Markedagain)
Date: 08/03/2013
*/
function init_tabs() {
	bindTab('history_questions', '.journal.question,.journal.question-closed', false, true);
	bindTab('history_time', '.journal.has-time', true, true);
	bindTab('history_private', '.journal.private-notes', false, true);
	bindTab('history_comments', '.journal.has-notes', false, true);
	bindTab('history_activity', '.journal.has-details', true, false);
	bindTab('history_all', '.journal', true, true);
	$('.tab-history.selected').not('#tab-history_all')[0] && $('.tab-history.selected').not('#tab-history_all')[0].click();
}

function bindTab(tab, journal, show_activity, show_note){
	$('#tab-'+tab).click(function(){
		$('.tab-history').removeClass('selected');
		$('#tab-'+tab).addClass('selected');
//		if("replaceState" in window.history){
//			window.history.replaceState(null,document.title,'?tab='+tab);
//		}
		$('.journal').hide();
		$(journal + ' .details').toggle(show_activity);
		$(journal + ' .wiki').toggle(show_note);
		$(journal).show();
	});
}

$(document).ready(function(){
  init_tabs();
});