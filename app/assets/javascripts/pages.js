function startShow() {
  var slides = $('div.slide');
  slides.mouseenter(function() {
    clearInterval( parseInt($('#intervalID').text()) );
  });
  slides.mouseleave(function() {
    $('#intervalID').text( setInterval("decSlideTimer()", 1000) );
  });

  $('#nextslide').click(function() {
    setSlide((slideNo() + 1) % numSlides());
  });
  $('#prevslide').click(function() {
    setSlide((slideNo() + numSlides() - 1) % numSlides());
  });

  $('#intervalID').text( setInterval("decSlideTimer()", 1000) );
}

function slideNo() {
  return parseInt($('#slideNo').text());
}

function numSlides() {
  return $('div.slide').length;
}

function resetTimer(time) {
  if(time === undefined) { 
    var time = 6;
  }
  $('#slideTimer').text(time + '');
}

function decSlideTimer() {
  var numsecs = parseInt($('#slideTimer').text());
  if(numsecs > 0) {
    resetTimer(numsecs - 1);
    return;
  }

  setSlide((slideNo() + 1) % numSlides());
}

function setSlide(num) {
  var oldslide = $('div.slide.selected');
  var newslide = $('div.slide:eq(' + num + ')');

  oldslide.fadeOut();
  newslide.fadeIn();
  oldslide.removeClass("selected")
  newslide.addClass("selected");

  $('#slideNo').text(num);
  resetTimer();
}

function setPageFunc(name, height) {
  return function() { 
    $('.staticpage').hide();
    $('#'+name).show();
    //$('#container').attr('style', 'height:'+height+'px;');
    $('.navbar-fixed-top li').removeClass("active");
    $('#'+name+'link').parent().addClass("active");
  };
}

var goHome = setPageFunc('home', 510);
var goFeatures = setPageFunc('features', 900);
var goAbout = setPageFunc('about', 525);
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
  $('.features').collapse();

  $('#homelink').click(goHome);
  $('#featureslink').click(goFeatures);
  $('#aboutlink').click(goAbout);
  $('#signinlink').click(goSignin);
});
