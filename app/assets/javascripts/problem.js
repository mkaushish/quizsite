function hideProblem() {
  $('#pr_dim').hide();
  $("body").css("overflow", "scroll");
  return false;
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length > 0) {
    dimmer.hide();
  }
  $('#dimmer').show();
}

function initProblemOverlay() {
  var dimmer = $('#dimmer');
  if($('#pr_dim').length == 0){
    $('body').prepend("<div id=pr_dim></div>");
  }
  if(dimmer.length == 0) {
    
    $('#pr_dim').prepend("<div id=dimmer onclick='hideProblem();'></div>");
    dimmer = $('#dimmer');
  }
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('#pr_dim').append("<div id=problem_overlay class=problem_overlay></div>");
   $p = $('#problem_overlay');
  }
  $("body").css("overflow", "hidden");
  $('#pr_dim').show();
  dimmer.show();
  $p.show();
  //closeWithDimmer();
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

function awesome(){
  AWESOME=['Awesome!! Try Another!', 'Fantastic! You\'re almost done with this Problem Type! Try Another!', 'You\'re making everyone else look bad! Keep at it! Try Another']
  $("#problem_overlay").append("<div class=awesome id=awesome><p>"+AWESOME[Math.round(Math.random()*(AWESOME.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>");
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}
function shit(){
  SHIT=['Try Another!', 'Keep on Working at it!!', 'You will get there! Try another!'];
  t="<div class=awesome id=shit><p>"+SHIT[Math.round(Math.random()*(SHIT.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>";
  $("#problem_overlay").append(t);
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}
function done_pr(){
  DONEP=['Try Another Problem Type! This one is already Blue!', 'There are other Problem Types Available!! Don\'t hoard this one!!', 'The other Problem Types are feeling lonely!!! Try one of them!'];
  $("#problem_overlay").append("<div class=awesome id=donep><p>"+DONEP[Math.round(Math.random()*(DONEP.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>");
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}