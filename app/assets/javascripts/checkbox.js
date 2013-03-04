(function ($) {
  function name(elt) {
    return elt.attr('href').substr(1);
  }

  function hidden_field(elt) {
    return $('[name="' + name(elt) + '"]');
  }

  function has_hidden_field(elt) {
    return hidden_field(elt).length >= 1;
  }

  function add_hidden_field(elt) {
    console.log('adding hidden_fiel?d ' + elt + ' : ' + name(elt) + ' ' + has_hidden_field(elt));
    if(!has_hidden_field(elt)) {
      console.log('adding hidden_field');
      elt.after('<input name="' + name(elt) + '" id="' + 
                  name(elt) + '" type="hidden" value="1">');
      console.log('success: ' + has_hidden_field(elt));
    }
  }

  function remove_hidden_field(elt) {
    hidden_field(elt).remove();
  }

  function check(elt) {
    elt.removeClass("unchecked");
    elt.addClass("checked");
    add_hidden_field(elt);
  }

  function uncheck(elt) {
    elt.removeClass("checked");
    elt.addClass("unchecked");
    remove_hidden_field(elt);
  }

  function swaptext(elt) {
    var tmp = elt.attr('data-alt');
    if(tmp == undefined) { return; }

    elt.attr('data-alt', elt.text());
    elt.text(tmp);
  }

  $.fn.checkBox = function(){
    return this.each( function() {
      var $elt = $(this);

      if($elt.hasClass("checked") && !has_hidden_field($elt)) {
        add_hidden_field($elt);
      }

      $elt.mouseup(function() {
        if($elt.hasClass("checked")) {
          uncheck($elt);
        } else {
          check($elt);;
        }
        swaptext($elt)
      });
    });
  }
})($);
