function setCurQuiz() {
  var quiz_s = "<li class='nav-header'>Current Quiz</li>";
  $(':checkbox:checked').each(function() {
    var problemname = $(this).attr("name").split("::")[1];
    quiz_s = quiz_s + "<li>"+problemname+"</li>";
  });
  $('#curquiz').html(quiz_s);
}

function bind_mt_fields() {
  $('.add_mt_field').unbind('click');
  $('.add_mt_field').bind('click', function() {
    var fields = $(this).siblings("div").children("input");
    var num = fields.length;

    var new_field = fields.first().clone()
    var new_id_name = new_field.attr("id").replace(/0/g, (num+""));

    new_field.attr("id",   new_id_name);
    new_field.attr("name", new_id_name);
    new_field.attr("value", "");

    fields.last().after(new_field);
  });

  $('.del_mt_field').unbind('click');
  $('.del_mt_field').bind('click', function() {
    var fields = $(this).siblings("div").children("input");
    var num = fields.length;

    if(num > 1) {
      fields.last().remove();
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

  bind_mt_fields();
});
