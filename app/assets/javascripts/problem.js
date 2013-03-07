function hideProblem() {
  $('#problem_overlay').hide();
  $('#dimmer').hide();
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('body').prepend("<div id=dimmer></div><div id=problem_overlay></div>");
   $p = $('#problem_overlay');
  }

  $p.show();
  $("#dimmer").show();
  $("#dimmer").click(hideProblem);
  return $p;
}
