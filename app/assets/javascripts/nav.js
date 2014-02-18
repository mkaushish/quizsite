function setNavLineWidths() {
  $('.nav-line').css("width", $(".container").css("width"));
  $('.nav-line').each(function () {
    var $elt = $(this)
      , $target = $('#' + $elt.attr('data-target'))
      , target_off = $target.offset()
      , target_w = $target.outerWidth()
      , target_h = $target.outerHeight()
      , target_y = parseInt($target.css("margin-top"))
      , $blue = $elt.children(':first-child')
      , $green = $elt.children(':last-child')
      , $both = $elt.children();

    var blue_w  = target_off.left
      , blue_y  = parseInt($blue.css('height')) // don't want borders
      , green_x = blue_w + target_w/2
      , green_w = Math.max($('.container').width() - green_x, 940 - green_x)
      , both_y  = 25 // (target_h / 2) - blue_y  + target_y
                               //  green should have same height

    // console.log($.param(target_off) + ': target_off');
    // console.log(target_w + ': target_w');
    // console.log(target_h + ': target_h');
    // console.log(target_y + ': target_y');
    // console.log(blue_w  + ': blue_w ');
    // console.log(blue_y  + ': blue_y ');
    // console.log(green_x + ': green_x');
    // console.log(green_w + ': green_w');
    // console.log(both_y  + ': both_y ');

    $blue.css("width", blue_w);
    $green.css("left", $(".container").css("margin-left"));

    $green.css("width", "100%");

    //$both.css("top", both_y)
  });
}
function dbord(pname){
  if($(".container").width() <= 722){
    $(".dotted-border").css("width", ($(".container").width()-22)+"px");
    $(".dotted-border").css("height","auto");
    $('#bbor').css('margin-left', '0px');
  }
  else{
    $(".dotted-border").css("width", "277px");
    $('#bbor').css('margin-left', '43px');
  }
  if(pname=="pset"){shelf_color();}
  else{shelf_color_in(pname[0], pname[1], pname[2]);}
  $(window).resize(function(){
  if($(".container").width() <= 722){
    $(".dotted-border").css("width", ($(".container").width()-22)+"px");
    $(".dotted-border").css("height","auto");
    $('#bbor').css('margin-left', '0px');
  }
  else{
    $(".dotted-border").css("width", "277px");
    $('#bbor').css('margin-left', '43px');
  }
  if(pname=="pset"){shelf_color();}
  else{shelf_color_in(pname[0], pname[1], pname[2]);}
});
}


$(function() {
  setNavLineWidths();
  $(window).resize(setNavLineWidths);
  
  
});
function logoutb(){
  $(".switch-to a").hover(function(){
    $(this).text("Are you sure?");},
    function(){$(this).text("Log out");}
  );
}
function rsize(){
  if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)){
    $("body").css("width", "457px");
    $("body").css("zoom", ""+($(window).width()/457));
  }
}
function shelf_do(){
  if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)){
    $("body").css("width", "457px");
    $("body").css("zoom", ""+($(window).width()/457));
  }
  wdt=$(".container").width();
lis="";
  lisarr=[]
  lis+="<li class=shelf_li id=account>"+$(".shelf .shelf_ul .shelf_li").eq(0).html()+"</li>";
  lisarr[0]="<li class=shelf_li id=account>"+$(".shelf .shelf_ul .shelf_li").eq(0).html()+"</li>";
  for(i=1; i < $(".shelf .shelf_ul .shelf_li").length; i++){
    lis+="<li class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
    lisarr[i]="<li class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
  }
  $(".shelf").remove();
  for(i=0; i < lisarr.length; i++){
    n = parseInt(($(".container").width()-200)/86);
    te=(lisarr.slice(i, (i+n))).join("\n");
    $("#bigshelf").append("<div class=shelf><ul class=shelf_ul>"+te+"</ul><div class='bot_bor'></div></div>");
    i=i+n-1;
  }
  liwt=parseInt($(".shelf .shelf_ul .shelf_li").css("width"))+2*parseInt($(".shelf .shelf_ul .shelf_li").css("padding"));
  wdt=$(".container").width();
$(window).resize(function(){
  if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)){
    $("body").css("width", "457px");
    $("body").css("zoom", ""+($(window).width()/457));
  }
  lisob=$(".shelf ul li");

  if(Math.abs($(".container").width()-wdt) > 10 ){
  lis="";
  lisarr=[]
  for(i=0; i < $(".shelf .shelf_ul .shelf_li").length; i++){
    lis+="<li  class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
    lisarr[i]="<li  class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
  }
  $(".shelf").remove();
  for(i=0; i < lisarr.length; i++){
    n = parseInt(($(".container").width()-200)/liwt);
    te=(lisarr.slice(i, (i+n))).join("\n");
    $("#bigshelf").append("<div class=shelf><ul class=shelf_ul>"+te+"</ul><div class='bot_bor'></div></div>");
    i=i+n-1;
  }
  wdt=$(".container").width();
}
badges_look();
});
}
