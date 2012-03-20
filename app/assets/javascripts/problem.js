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
});
