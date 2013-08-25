/*
Author: Daniel Munn <https://github.com/danmunn
Date: 23/05/2012
Forked & Redone: Mark Kalender (Markedagain)
Date: 08/03/2013
*/
function init_tabs() {
	bindTab('tabtime_questions', '.journal.question,.journal.question-closed');
	bindTab('tabtime_time', '.journal.has-time');
	bindTab('history_private', '.journal.private-notes');
	bindTab('history_comments', '.journal.has-notes');
	bindTab('history_activity', '.journal.has-details');
	bindTab('history_all', '.journal');
	$('.tab-history.selected').not('#tab-history_all')[0] && $('.tab-history.selected').not('#tab-history_all')[0].click();
}

function bindTab(tab, journal){
	$('#tab-'+tab).click(function(){
		$('.tab-history').removeClass('selected');
		$('#tab-'+tab).addClass('selected');
		if("replaceState" in window.history){
			window.history.replaceState(null,document.title,'?tab='+tab);
		}
		$('.journal').hide();
		$(journal).show();
	});
}

$(document).ready(function(){
  init_tabs();
});