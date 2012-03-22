function startShow() {
  setInterval("nextSlide()", 1000);
}

function resetTimer(time) {
  if(time === undefined) { 
    var time = 6;
  }
  $('#slideTimer').text(time + '');
}

function nextSlide() {
  var numsecs = parseInt($('#slideTimer').text());
  if(numsecs > 0) {
    resetTimer(numsecs - 1);
    return;
  }
  var slideno = parseInt($('#slideNo').text());
  slideno %= 3;
  //alert("switching to slide " + slideno);
  var nextslide = $('#slideshownav li').toArray()[slideno];
  if(!$(nextslide).hasClass("selected")) { $(nextslide).click(); }
}

function setSlide(num, sender) {
  $('#slideshownav li').removeClass();
  $(sender).addClass("selected");
  $('#slides').children().fadeOut();
  $('#slide'+num).fadeIn();
  $('#slideNo').text(num);
  resetTimer();
}

function setPageFunc(name, height) {
  return function() { 
    $('.staticpage').hide();
    $('#'+name).show();
    $('#container').attr('style', 'height:'+height+'px;');
    $('nav a').removeClass("selected");
    $('#'+name+'link').addClass("selected");
  };
}

var goHome = setPageFunc('home', 510);
var goFeatures = setPageFunc('features', 510);
var goAbout = setPageFunc('about', 510);
var goSignin = setPageFunc('signin', 510);

var homeOnLoad = function(pagename) {
  startShow();
  if(pagename === "features") {
    goFeatures();
  }
  else if(pagename === "about") {
    goAbout();
  }
  else if(pagename === "signin") {
    goSignin();
  }
  else {
    goHome();
  }
}

$(document).ready(function() {
  $('#team').mouseenter(function() {
    $('#aboutnav div').removeClass("selected");
    $("#team").addClass("selected");
    $('.contact').hide();
    $('.team').show();
  });
  $('#contact').mouseenter(function() {
    $('#aboutnav div').removeClass("selected");
    $("#contact").addClass("selected");
    $('.team').hide();
    $('.contact').show();
  });

  $('#homelink').mouseenter(goHome);
  $('#featureslink').mouseenter(goFeatures);
  $('#aboutlink').mouseenter(goAbout);
  $('#signinlink').mouseenter(goSignin);
});
