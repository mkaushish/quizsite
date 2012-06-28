(function ($) {
  "user strict";

  /* PERMUTATIONDRAG CLASS DEFINITION
   * ================================ */

  var PermutationDrag = function(element) {
    this.$element = $(element);
    this.padding = parseInt(this.$element.css('padding-right').replace(/px/, ''));
    this.box = undefined;
    this.read_elts();
    console.log(this.padding);
    
    $(element).css('height', this.height);
    $(element).css('width', this.width);
    var offset   = this.$element.offset();
    this.offsetx = Math.round(offset.left);
  }

  PermutationDrag.prototype = {
    read_elts : function() {
    console.log(this.padding);
      elts = []
        , l_off = this.padding 
        , max_height = 0

      this.$element.children('div').each( function(i) {
        elts.push( new PermBox( $(this), i, l_off ) );
        l_off += $(this).outerWidth(); // pass true here if we want to include margins
        max_height = Math.max(max_height, $(this).outerHeight());
      });

      this.width = l_off - this.padding;
      this.height = max_height;
      this.elts = elts;
    }

    , swap_elts : function(i, j) {
      console.log ( "swapping " + i + " and " + j);
      var tmp = this.elts[i];

      this.elts[i]   = this.elts[j];
      this.elts[i].set_i(i);

      this.elts[j] = tmp;
      this.elts[j].set_i(j);
    }

    , slide_left : function(box) {
      if(box.i <= 0) return; 

      this.swap_elts(box.i, (box.i - 1));

      var prev_box = this.elts[box.i - 1];
      box.slide_to((prev_box == undefined) ? this.padding : prev_box.r_off);
    }

    , slide_right : function(box) {
      if(box.i + 1 >= this.elts.length) return; 

      this.swap_elts(box.i, box.i + 1);
      console.log(this.elts[box.i - 1].width);
      box.slide_to(box.l_off + this.elts[box.i - 1].width());
    }

    , mouse_is_down : function() {
      return this.box != undefined;
    }

    , mousedown : function(e) {
      var mousex = e.pageX - this.offsetx;

      for(var i = 0; i < this.elts.length; i++) {
        if(mousex <  this.elts[i].r_off) {
          this.box = this.elts[i]
          this.mouse_off = mousex - this.elts[i].l_off;
          break;
        }
      }
    }

    , mouseup : function(e) {
      if(this.box == undefined) return;

      if(this.box.i == 0) {
        this.box.slide_to(this.padding);
      }
      else {
        this.box.slide_to( this.elts[this.box.i - 1].r_off );
      }
      this.box = undefined;
    }

    , mousemove : function (e) {
      if(this.mouse_is_down()) {
        var l_off  = e.pageX - this.offsetx - this.mouse_off
          , box    = this.box
          , next_b = this.elts[box.i + 1]
          , prev_b = this.elts[box.i - 1];

        if(next_b == undefined) {
          var edge = prev_b.r_off;
          if(l_off > edge) {
            box.set_l_off(edge + (4 * Math.log(l_off - edge)));
          }
          else box.set_l_off(l_off);
        }
        else if(prev_b == undefined) {
          var edge = this.padding;
          if(l_off < edge) {
            box.set_l_off(edge - (4 * Math.log(edge - l_off)));
          }
          else box.set_l_off(l_off);
        }
        else {
          box.set_l_off(l_off);
        }

        if(next_b != undefined && box.r_off > next_b.middle()) {
          this.slide_left(next_b)
        }

        if(prev_b != undefined && box.l_off < prev_b.middle()) {
          this.slide_right(prev_b)
        }

      }
    }
  }

  /* PERMBOX CLASS DEFINITION
   * ======================== */
  var PermBox = function(element, i, l_off) {
    this.$element = element;
    this.i = i;
    this.set_l_off(l_off);
  }

  PermBox.prototype = {
    width: function() {
      return this.$element.outerWidth();
    }

    , set_l_off : function(l_off) {
      this.l_off = l_off;
      this.$element.css('left', l_off);
      this.r_off = l_off + this.width();
    }

    , middle : function() {
      return (this.l_off + this.r_off) / 2;
    }

    , slide_to : function(l_off) {
      this.$element.animate({ left : (l_off + "px") });
      this.set_l_off(l_off);
    }

    , set_i : function(i) {
      this.i = i;
      this.$element.children('input').attr('value', i);
    }

    //, toString : function() {
    //  return this.$element.attr('id')
    //}
  }

  /* PERMUTATIONDRAG PLUGIN DEFINITION
   * ================================= */
  $.fn.permutationDrag = function() {
    // this.each so you can call $('.permutationDrag').permutationDrag();, and it will apply to all elts
    return this.each( function() {
      var $this = $(this),
          data = $this.data('permutationDrag');

      if(!data) $this.data('permutationDrag', (data = new PermutationDrag(this)))
      $this.mousemove(function(e) { data.mousemove(e) });
      $this.mousedown(function(e) { data.mousedown(e) });
      $this.mouseup(function(e) { data.mouseup(e) });
      $this.mouseleave(function(e) { data.mouseup(e) });
    });
  };
} ) ( jQuery );
