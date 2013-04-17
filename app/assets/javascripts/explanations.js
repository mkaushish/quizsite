// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function hideExplanation(){
	$('#problem_overlay .explanation').hide();
	$('#problem_overlay .problem').show();
	$('#hide_explanation').replaceWith(
		'<a class="button-blue" id="see_explanation" href="#" ' +
		'onclick="showExplanation(); return false;">See Explanation</a>'
		);
  initProblem();
  closeWithDimmer();
}

function showExplanation(){
	$('#problem_overlay .explanation').show();
	$('#problem_overlay .problem').hide();
	$('#see_explanation').replaceWith(
		'<a class="button-blue" id="hide_explanation" href="#" ' +
		'onclick="hideExplanation(); return false;">Stop Explanation</a>'
		);
  initProblem();
  closeWithDimmer();
}
