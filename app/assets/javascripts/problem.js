function hideProblem() {
  $('#problem_overlay').hide();
  $('#dimmer').hide();
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div><div id=problem_overlay></div>");
    dimmer = $("#dimmer");
  }
  else {
    dimmer.unbind("click");
  }

  dimmer.show();
  dimmer.click(hideProblem);
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $p = $('#problem_overlay');
  }

  $p.show();
  closeWithDimmer();
  return $p;
}
