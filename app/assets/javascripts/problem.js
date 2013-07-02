function hideProblem() {
  $('#dimmer').unbind('click');

  $('#problem_overlay').hide();
  // $('#dimmer').hide();
  $('#dimmer').remove();
    $("body").css("overflow", "scroll");

  return false;
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length > 0) {
    dimmer.remove();
  }
  $('body').prepend("<div id=dimmer onclick='hideProblem();'></div>");
  $('#dimmer').show();
  // $('#dimmer').click(hideProblem);
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('body').prepend("<div id=problem_overlay class=problem_overlay></div>");
   $p = $('#problem_overlay');
  }
  $("body").css("overflow", "hidden");
  var dimmer = $('#dimmer');
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div>");
    dimmer = $('#dimmer');
  }

  $p.show();
  closeWithDimmer();
  return $p;
}
