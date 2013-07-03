function hide_custom_problem_form() {
  $('#dimmer').unbind('click');

  $('#custom_problem_form').hide();
  $('#custom_problem_form').find('.input-field,textarea').attr('value', '');
  $('#dimmer').hide();
}
