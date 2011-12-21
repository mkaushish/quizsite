// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function () {
  $('.add_mt_field').click(function() {
    var num = $(this).siblings(".mt_field").length;
    var new_field = $(this).attr('template').replace(/_num_/g, num);

    $(this).siblings(".del_mt_field").attr("disabled","");
    $(this).before(new_field);
  });

  $('.del_mt_field').click(function() {
    var num = $(this).siblings(".mt_field").length;

    if(num >= 1) {
      $(this).siblings(".mt_field").last().remove();
    }
  });
});
