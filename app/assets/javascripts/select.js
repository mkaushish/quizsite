$(document).ready(function(){ 
  format_select_arrow();
});

function format_select_arrow() {
  if (!$.browser.opera) {

    $('select.select').each(function(){
      var title = $(this).attr('title')
        , width = $(this).width()
        , height = $(this).height()
        , position = $(this).position();

      if( $('option:selected', this).length > 0 ) {
        title = $('option:selected', this).text();
      }

      $(this)
      .css({'z-index':10,
            'opacity':0,
            '-khtml-appearance':'none' })
      .after('<span class="select" style="height:' + height + 
                                       'px;width:' + width + 
                                       'px;left:' + position.left + 
                                       'px;top:' + position.top + 
                                       'px;">' + title + '</span>')
      .change(function(){
        val = $('option:selected',this).text();
        $(this).next().text(val);
      })
    });

  };
}
