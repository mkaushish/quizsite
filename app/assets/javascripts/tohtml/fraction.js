function centerFractionInts() {
  $('.fraction .int').each(function() {
    var $i = $(this)
      , $total_height = $i.parent().height();

    $i.css('top', $total_height / 2)
    $i.css('margin-top', (0-$i.outerHeight())/ 2)
  });
}

INIT_PROBLEM['fraction'] = centerFractionInts;
