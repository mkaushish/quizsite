function hideProblem() {
  $('#problem_overlay').hide();
  $('#dimmer').hide();
}

function centerFractionInts() {
  $('.fraction .int').each(function() {
    var $i = $(this)
      , $total_height = $i.parent().height();

    $i.css('top', $total_height / 2)
    $i.css('margin-top', (0-$i.outerHeight())/ 2)
  });
}

function rel_mt_fields(btn) {
  return btn.siblings("div").children("input");
}

function set_mt_field_ids(fields) {
  blank_field = fields.first().attr("id").replace(/[0-9]*$/, "");
  for(var i = 0; i < fields.length; i++) {
    fields[i].id = blank_field + i;
    fields[i].name = blank_field + i;
  }
}

function bind_mt_buttons() {
  $('.add_mt_field').unbind('click');
  $('.add_mt_field').bind('click', function() {
    var fields = rel_mt_fields($(this));

    var new_field = fields.first().clone()
    new_field.attr("value", "");

    fields.last().after(new_field);
    fields = rel_mt_fields($(this));

    set_mt_field_ids(fields);
    bind_mt_fields();
    fields.last().select();

  });

  $('.del_mt_field').unbind('click');
  $('.del_mt_field').bind('click', function() {
    var fields = rel_mt_fields($(this));
    var num = fields.length;

    if(num > 1) {
      fields.last().remove();
    }
    rel_mt_fields($(this)).last().select()
  });

  bind_mt_fields();
}

function bind_mt_fields() {
  $('.multifield div input').unbind('keydown');
  $('.multifield div input').keydown(function (e) {
    //alert("keycode = " + e.keyCode );
    // shift-space, shift-enter, ctrl-space, ctrl-enter
    if((e.keyCode == 32 || e.keyCode == 13) && (e.shiftKey || e.ctrlKey)) {
      $(this).parent().siblings(".add_mt_field").click();
      e.preventDefault();
    }
    // backspace
    else if(e.keyCode == 8) {
      if($(this).attr("value") == "") {
        var mom = $(this).parent();
        if(mom.children().length > 1) {
          $(this).remove();

          set_mt_field_ids(mom.children());
          var emptykids = mom.children('input[value=""]');
          if(emptykids.length > 0) {
            emptykids.last().select();
          }
          else {
            mom.children().last().select();
          }
        }

        e.preventDefault();
      }
    }
  });
}

$(document).ready(function () {
  $('#clear-quiz').click(function() {
    $(':checkbox:checked').attr('checked', false);
    setCurQuiz();
  });

  $('#problemtabs :checkbox').click(function() {
    setCurQuiz();
  });

  $('.checkbox-item.incorrect').tooltip();
  // $('body').click(hideProblem)
});
