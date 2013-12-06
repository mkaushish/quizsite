function set_stat_widths(elt, total) {
  console.log(stats.find('li:eq(2)').first().attr('data-original-title')); 
  if(total == undefined) { total = false; }

  elt.children('ul').each( function() {
    var scores = $(this).children('li:gt(0)')
      , width = (940 - 400) / scores.length;
    
    scores.each( function() { 
      var percent = parseInt( $(this).attr('data-width') )
        , kid = $(this).children('div').first()

      //console.log(percent + '');

      if(total) {
        $(this).width(width * percent / 100.0);
        kid.width('100%');
      } else {
        $(this).width(width);
        kid.width(percent + '%');
      }
    });
  });
}
