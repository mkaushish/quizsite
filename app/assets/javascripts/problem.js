function hideProblem() {
  $('#problem_overlay').hide();
  // $('#dimmer').hide();
  $('#dimmer').remove();
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length > 0) {
    dimmer.remove();
  }
  dimmer = $('body').prepend("<div id=dimmer onclick='hideProblem(); return false;'></div>");
  dimmer.show();

  // else {
  //   dimmer.unbind("click");
  // }

  // dimmer.show();
  // dimmer.click(hideProblem);
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('body').prepend("<div id=problem_overlay></div>");
   $p = $('#problem_overlay');
  }

  $p.show();
  closeWithDimmer();
  return $p;
}
