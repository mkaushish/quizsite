function setNavLineWidths() {
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
      , green_w = Math.max($(window).width() - green_x, 940 - green_x)
      , both_y  = 25 // (target_h / 2) - blue_y  + target_y
                               //  green should have same height

    console.log($.param(target_off) + ': target_off');
    console.log(target_w + ': target_w');
    console.log(target_h + ': target_h');
    console.log(target_y + ': target_y');
    console.log(blue_w  + ': blue_w ');
    console.log(blue_y  + ': blue_y ');
    console.log(green_x + ': green_x');
    console.log(green_w + ': green_w');
    console.log(both_y  + ': both_y ');

    $blue.css("width", blue_w);
    $green.css("left", green_x);
    $green.css("width", green_w);

    $both.css("top", both_y)
  });
}

$(function() {
  setNavLineWidths();
  $(window).resize(setNavLineWidths);
});
