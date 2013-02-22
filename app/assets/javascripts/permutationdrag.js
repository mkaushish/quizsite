(function ($) {
  "user strict";

  /* PERMUTATIONDRAG CLASS DEFINITION
   * ================================ */

  var PermutationDrag = function(element) {
    this.$element = $(element);
    //this.padding = parseInt(this.$element.css('padding-right').replace(/px/, ''));
    this.gap = 10;
    this.box = undefined;
    this.read_elts();

    $(element).css('height', this.height);
    $(element).css('width', this.width);
    var offset   = this.$element.offset();
    this.offsetx = Math.round(offset.left);
  }

  PermutationDrag.prototype = {
    read_elts : function() {
      this.elts = [];
      var max_height = 0
        , l_off = 0
        , p = this
        , l = 0; // length of elts


      this.$element.children('div').each( function(i) {
        l = p.elts.push( new PermBox( $(this), i, l_off) );
        max_height = Math.max(max_height, $(this).outerHeight());

        l_off += p.elts[l-1].width + p.gap
        console.log(l_off + " " +p.elts[l-1]);
      });

      this.height = max_height;
      this.width = this.box_x(this.elts[l-1]) + this.elts[l-1].width;
    }

    , write_order : function() {
      this.$element.children('input').attr('value', this.elts.join(","));
    }

    // theoretical x position of elts[i] - linear search. Since elts is generally small you shouldn't
    // usually bother to save the result of this function
    // and if we did want to we should just memoize here and update on swap_elts()
    , box_x : function(box) {
      len = 0;
      for(var i = 0; i < box.i; i++) {
        len += this.elts[i].width + this.gap;
      }
      return len;
    }

    , next_movable_elt : function(box, inc) {
      for(var i = (box.i + inc); 0 <= i && i < this.elts.length; i += inc) {
        if(!this.elts[i].fixed) { return this.elts[i] }
      }
      return undefined;
    }

    // Switches boxes i and j
    // - slides j to i's previous position
    // - nothing is done to the position of i, because i is assumed to be in the mouse
    , swap_elts : function(b_i, b_j) {
      var i = b_i.i
        , j = b_j.i

      b_j.set_i(i);
      b_i.set_i(j);

      this.elts[j] = b_i
      this.elts[i] = b_j 

      b_j.slide_to(this.box_x(b_j))

      // slide elts in between j and i to their new places
      // only necessary for fixed elements
      var inc = (j > i) ? +1 : -1
      for(var i = (i + inc); i != j; i += inc) {
        this.elts[i].slide_to(this.box_x(this.elts[i]))
      }

      this.write_order();
    }

    , mouse_is_down : function() {
      return this.box != undefined;
    }

    , mousedown : function(e) {
      var mousex = e.pageX - this.offsetx;

      // get the box we clicked on unless it's fixed
      for(var i = this.elts.length - 1; i >= 0; i--) {
        // console.log(this.box_x(this.elts[i]));
        if(mousex > this.box_x(this.elts[i])) {
          if(this.elts[i].fixed){
            return 0;
          }

          this.box = this.elts[i];
          this.mouse_off = mousex - this.box_x(this.box)
          break;
        }
      }

      // increase the z-index of this box so it's above the others
      this.box.inc_z();
    }

    , mouseup : function(e) {
      if(this.box == undefined) return;

      this.box.slide_to(this.box_x(this.box));
      this.box.dec_z();
      console.log('z-index: ' + this.box.$element.css('z-index'));
      this.box = undefined;
    }

    , mousemove : function (e) {
      if(this.mouse_is_down()) {
        var l_off  = e.pageX - this.offsetx - this.mouse_off
          , box    = this.box
          , next_b = this.next_movable_elt(box, +1)
          , prev_b = this.next_movable_elt(box, -1);

        // if we're off the edges, stay at the edge and return
        if( (next_b == undefined && l_off > this.box_x(box)) || (prev_b == undefined && l_off < 0) ) {
          box.set_l_off(this.box_x(box));
          return 1;
        } 

        else {
          box.set_l_off(l_off);
        }

        // now we swap with the next elt if the overlap in our current state is bigger
        // than the overlap in the best alternative state
        var overlap = l_off - this.box_x(box);

        if(overlap > 0) {
          // next_b must be defined, or we're at the edge and would have returned
          var overlap_n = (this.box_x(next_b) - box.width + next_b.width) - l_off;
          if(overlap > overlap_n) { this.swap_elts(box, next_b); }
        }
        else if(overlap < 0) {
          var overlap_n = l_off - this.box_x(prev_b);
          if(-overlap > overlap_n) { this.swap_elts(box, prev_b); }
        }
        return 1;
      }
    }
  }

  /* PERMBOX CLASS DEFINITION
   * ======================== */
  var PermBox = function(element, i, l_off) {
    this.$element = element;
    this.i = i;
    this.set_l_off(l_off);
    this.width = element.outerWidth();
    this.fixed = this.$element.hasClass('fixed');
  }

  PermBox.prototype = {
    set_l_off : function(l_off) {
      this.l_off = l_off;
      this.$element.css('left', l_off);
    }

    , middle : function() {
      return this.l_off + Math.floor(this.width / 2)
    }

    , slide_to : function(l_off) {
      this.$element.animate({ left : (l_off + "px") });
      this.l_off = l_off;
    }

    , set_i : function(i) {
      this.i = i;
    }

    , toString : function() {
      return this.$element.text();
    }

    , inc_z : function() {
      var z = parseInt(this.$element.css('z-index'));
      this.$element.css('z-index', z+1);
    }

    , dec_z : function() {
      var z = parseInt(this.$element.css('z-index'));
      this.$element.css('z-index', z-1);
    }
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
