function set_stat_widths(elt) {
  elt.children('ul').each( function() {
    var scores = $(this).children('li:gt(0)')
      , width = (940 - 400) / scores.length;
    
    scores.each( function() { 
      $(this).width(width);
    });
  });
}
