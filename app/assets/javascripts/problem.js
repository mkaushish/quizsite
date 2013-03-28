function hideProblem() {
  $('#dimmer').unbind('click');

  $('#problem_overlay').hide();
  $('#dimmer').hide();
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('body').prepend("<div id=problem_overlay class=problem_overlay></div>");
   $p = $('#problem_overlay');
  }

  var dimmer = $('#dimmer');
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div>");
    dimmer = $('#dimmer');
  }

  $p.show();
  dimmer.show();
  dimmer.click(hideProblem);
  return $p;
}
