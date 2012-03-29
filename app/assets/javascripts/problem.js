$(document).ready(function () {
  $('.add_mt_field').click(function() {
    var num = $(this).siblings(".mt_field").length + 1;
    var new_field = $(this).attr('template').replace(/_num_/g, num);

    $(this).siblings(".del_mt_field").attr("disabled","");
    $(this).before(new_field);
  });

  $('.del_mt_field').click(function() {
    var num = $(this).siblings(".mt_field").length;

    if(num > 0) {
      $(this).siblings(".mt_field").last().remove();
    }
  });

  function setCurQuiz() {
    var quiz_s = "<li><h3>Current Quiz</h3></li>";
    $(':checkbox:checked').each(function() {
      var problemname = $(this).attr("name").split("::")[1];
      quiz_s = quiz_s + "<li class=quizelt>"+problemname+"</li>";
    });
    $('#curquiz').html(quiz_s);
  }

  $('#clear-quiz').click(function() {
    $(':checkbox:checked').attr('checked', false);
    setCurQuiz();
  });

  $('#problemtabs :checkbox').click(function() {
    setCurQuiz();
  });
});
