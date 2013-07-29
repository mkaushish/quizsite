function hideProblem() {
  $('#dimmer').unbind('click');

  $('#problem_overlay').hide();
  $("body").css("overflow", "scroll");
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
function bclr_pset(){
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  $(".pset_list_box").hover(function(){
    $(this).css("background-color",COLOR[Math.round(Math.random()*(COLOR.length-1))]);
  });
}
function bclr_problem(){
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  $(".problem_list_box").hover(function(){
    $(this).css("background-color",COLOR[Math.round(Math.random()*(COLOR.length-1))]);
  });
}
