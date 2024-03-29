// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_directory .
//= require_directory ./tohtml
//= require jquery.mousewheel
//= require jquery.jscrollpane.min
//= require jquery.countdown
//= require pnotify
//= require amcharts
//= require_tree .

$.pnotify.defaults.styling = "bootstrap3";
$.pnotify.defaults.history = false;

$(function() {
    $('.with_tooltip').tooltip();
});

function studentSubscribe() {
  setInterval(checkNotificationsStudent, 30000);
}

function checkNotificationsStudent() {
  $.ajax("/students/notify_student");
}

function teacherSubscribe() {
  setInterval(checkNotificationsTeacher, 30000);
}

function checkNotificationsTeacher() {
  $.ajax("/teachers/notify_teacher");
}