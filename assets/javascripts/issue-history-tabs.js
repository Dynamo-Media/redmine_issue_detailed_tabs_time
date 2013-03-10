/*
Author: Daniel Munn <https://github.com/danmunn
Date: 23/05/2012
Forked & Redone: Mark Kalender (Markedagain)
Date: 08/03/2013
*/
function init_tabs() {
	bindTab('#tab-tabtime_questions', '.journal.question,.journal.question-closed');
	bindTab('#tab-tabtime_time', '.journal.has-time');
	bindTab('#tab-history_private', '.journal.private-notes');
	bindTab('#tab-history_comments', '.journal.has-notes');
	bindTab('#tab-history_activity', '.journal.has-details');
	bindTab('#tab-history_all', '.journal');
}
function bindTab(tabName , journal){
	$(tabName).click(function(e){
		$('.tab-history').removeClass('selected')
		$(this).addClass('selected')
		show_history($(journal));
	 })
}
function show_history(tag) {
  $('.journal').hide();
  tag.show();
}

$(document).ready(function(){
  init_tabs();
});
