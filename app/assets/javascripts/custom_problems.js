function hide_custom_problem_form() {
  $('#dimmer').unbind('click');

  $('#custom_problem_form').hide();
  $('#custom_problem_form').find('.input-field,textarea').attr('value', '');
  $('#dimmer').hide();
}

// change the problem_type_id field for the custom_problem form
// and show it!
function custom_problem_form(ptype_id, ptype_name) {
  var cp_form = $('#custom_problem_form');
  if(cp_form.length == 0) {
    $('body').prepend("<div id=custom_problem_form class=problem_overlay></div>");
    cp_form = $('#custom_problem_form');
  }

  var dimmer = $('#dimmer');
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div>");
    dimmer = $('#dimmer');
  }

  cp_form.find('[name~=problem_type_id]').attr('value', ptype_id);
  cp_form.find('h2:first').text(ptype_name + ": Create Problem");
  cp_form.show();

  dimmer.show();
  dimmer.click(hide_custom_problem_form);
}
