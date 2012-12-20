function setNavLineWidths() {
  $('.nav-line').each(function () {
    var $elt = $(this)
      , $target = $('#' + $elt.attr('data-target'))
      , target_off = $target.offset()
      , target_w = $target.outerWidth()
      , $blue = $elt.children(':first-child')
      , $green = $elt.children(':last-child');

    var blue_w  = target_off.left
      , green_x = blue_w + target_w/2
      , green_w = Math.max($(window).width() - green_x, 940 - green_x)

    $blue.css("width", blue_w);
    $green.css("left", green_x);
    $green.css("width", green_w);
  });
}

$(document).ready(function() {
  setNavLineWidths();
  $(window).resize(setNavLineWidths);
});
