function registerAs(id) {
  initProblemOverlay();
  $('#dimmer').attr('onclick', '');
  $('#dimmer').click(function() {
    $('#new_'+id).appendTo('#hidden_registration_forms');
    hideProblem();
  });

  $('#problem_overlay').html('');
  $('#new_'+id).appendTo('#problem_overlay');
}

function registerStudent() {
  registerAs('student');
}

function registerTeacher() {
  registerAs('teacher');
}
