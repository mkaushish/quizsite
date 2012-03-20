function startShow() {
  setInterval("nextSlide()", 9000);
}

function nextSlide() {
  var slideno = parseInt($('#slideNo').text());
  slideno %= 3;
  //alert("switching to slide " + slideno);
  var nextslide = $('#slideshownav li').toArray()[slideno];
  if(!$(nextslide).hasClass("selected")) { $(nextslide).click(); }
  $('#slideNo').text((slideno + 1) + '');
}

function setSlide(num, sender) {
  $('#slideshownav li').removeClass();
  $(sender).addClass("selected");
  //$('#slides').children().hide();
  //$('#slide'+num).show();
  $('#slides').children().fadeOut();
  $('#slide'+num).fadeIn();
}
