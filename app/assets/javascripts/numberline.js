
function setUpNL(editable, movable, type) {
  // global drawing variables
  var canvas = $('#nlcanvas')[0];
  var context = canvas.getContext('2d');
  context.clearRect(0,0,canvas.width, canvas.height);
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var mousedown=false;
  var off=25;         // offset from edges
  var state;
  var zoompos = 180;
  var malNumLine={  
    num : 10,
    center : (canvas.width)/2, 
    snum : 10,
    mid : 0,
    diff : 1,
    bdivs : 1000,
    zbarc : zoompos,
    initz : zoompos,
    poi : [],
    inp : null,
    points : [],
    lines : [],
    zoomin : [1, 0.5, 0.25, 0.2, 0.1, 0.05],
    zoominf : [1, 2, 4, 5, 10, 20],          
    zoomout : [1, 2, 5, 10, 50, 100],
    ewid : Math.floor((canvas.width-2*off)/100),
    lower : 40,
    movable : movable,
    upper : 320,
    ldiv : 20,
    edit : editable,
    fdiff : 1,
    movemid : function() {
      var mmov=mousex-downx;
      downx=mousex
        this.center+=mmov;
    },
    zoom : function() {

           },
    moveZBar : function() {
                 var mmov=mousey-downy;
                 downy=mousey;
                 if (mmov+this.zbarc <= this.upper-this.ldiv-1 && mmov+this.zbarc >= this.lower+this.ldiv+1) {
                   this.zbarc+=mmov;

                   zoompos=this.zbarc;
                   if (this.zbarc < this.initz) {
                     this.diff=this.zoomout[Math.floor((this.initz-this.zbarc)/this.ldiv)];
                   }
                   else {
                     this.diff=this.zoomin[Math.floor((this.zbarc-this.initz)/this.ldiv)];
                     this.fdiff=this.zoominf[Math.floor((this.zbarc-this.initz)/this.ldiv)];
                   }
                 }
               },
    drawZBar : function() {
                 drawLine(5,this.lower,5,this.upper);
                 drawLine(5,this.upper,15,this.upper);
                 drawLine(15,this.upper,15,this.lower);
                 drawLine(15,this.lower,5,this.lower);
                 drawLine(5,this.zbarc-this.ldiv,5,this.zbarc+this.ldiv);
                 drawLine(5,this.zbarc+this.ldiv,15,this.zbarc+this.ldiv);
                 drawLine(15,this.zbarc+this.ldiv,15,this.zbarc-this.ldiv);
                 drawLine(15,this.zbarc-this.ldiv,5,this.zbarc-this.ldiv);
                 writeMessage("The small divs are " +this.diff/10+" and the big divs are "+this.diff);
               },
    draw : function(type) {
             var first=canvas.width-off;
             var last=off;
             var ct=0;
             for (i=this.center; i >= off; i-=this.ewid){
               if (i <= canvas.width-off) { 
                 drawLine(i, canvas.height-off, i, canvas.height-off-10);
                 if (ct==0) {last=i;}
                 ct+=1;
               } 
               first=i;
             }
             ct=0;
             for (i=this.center; i <=canvas.width-off; i+=this.ewid){
               if (i >= off){
                 drawLine(i, canvas.height-off, i, canvas.height-off-10);
                 if (ct==0 && first > i) {first=i;}
                 if(last < i) {last=i;}
                 ct+=1;
               }  
             }
             t=this.mid;
             var ct=this.mid;
             for (i=this.center; i >= off; i-=this.ewid*this.snum){
               if (i <= canvas.width-off) { 
                 drawLine(i, canvas.height-off, i, canvas.height-off-20);
                 this.poi.push(i);
                 if (i !=this.center) {
                   if (type == "dec" || this.diff >= 1){
                     context.font = "9pt Calibri";
                     if ((Math.round(t*1000)/1000).toString().length < 2) {
                       context.fillText(Math.round(t*1000)/1000, i-3, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 3) {
                       context.fillText(Math.round(t*1000)/1000, i-6, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 4) {
                       context.fillText(Math.round(t*1000)/1000, i-9, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 5) {
                       context.fillText(Math.round(t*1000)/1000, i-12, canvas.height-10);
                     }
                     else{
                       context.fillText(Math.round(t*1000)/1000, i-15, canvas.height-10);
                     }
                   }
                   else {
                     var num=-ct;
                     var den=this.fdiff;
                     var hcf=gcd(num, den);
                     num=Math.round(num/hcf);
                     den=Math.round(den/hcf);
                     context.font = "9pt Calibri";
                     if(den !=1){
                       context.fillText(-num, i-9, canvas.height-15);
                       context.fillText("__", i-9, canvas.height-15);
                       context.fillText(den, i-9, canvas.height-4)
                     }
                     else { context.fillText(-num, i-9, canvas.height-10); }
                   }
                 } 
               }
               t-=this.diff;
               ct-=1;
             }
             ct=0;
             t=this.mid
               for (i=this.center; i <=canvas.width-off; i+=this.ewid*this.snum){
                 if (i >= off){
                   drawLine(i, canvas.height-off, i, canvas.height-off-20);
                   this.poi.push(i);
                   if (type == "dec" || this.diff >= 1){
                     context.font = "9pt Calibri";
                     if ((Math.round(t*1000)/1000).toString().length < 2) {
                       context.fillText(Math.round(t*1000)/1000, i-3, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 3) {
                       context.fillText(Math.round(t*1000)/1000, i-6, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 4) {
                       context.fillText(Math.round(t*1000)/1000, i-9, canvas.height-10);
                     }
                     else if ((Math.round(t*1000)/1000).toString().length < 5) {
                       context.fillText(Math.round(t*1000)/1000, i-12, canvas.height-10);
                     }
                     else{
                       context.fillText(Math.round(t*1000)/1000, i-15, canvas.height-10);
                     }
                   }
                   else {
                     var num=ct;
                     var den=this.fdiff;
                     var hcf=gcd(num, den);
                     num=Math.round(num/hcf);
                     den=Math.round(den/hcf);
                     context.font = "9pt Calibri";
                     if(den !=1){
                       context.fillText(num, i-9, canvas.height-15);
                       context.fillText("__", i-9, canvas.height-15);
                       context.fillText(den, i-9, canvas.height-4)
                     }
                     else { context.fillText(-num, i-9, canvas.height-10); }
                   }
                 }
                 t+=this.diff;
                 ct+=1;
               }
             drawLine(first, canvas.height-off, last, canvas.height-off);
           }
  }
  malNumLine.draw("frac");
  if(type=="inpval"){
    malNumLine.inp=$("inp").attr("value");
  }
  if( malNumLine.edit ){
    malNumLine.drawZBar();
  }
  $('#nlcanvas').mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    mousedown=true;
  });

  $('#nlcanvas').mouseup(function (e) { 
    mousedown=false;
  });

  function setMouseXY(e) {
    var offset = $('#nlcanvas').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);

    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
  }
  $('#nlcanvas').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    setMouseXY(e);
    if(mousedown && malNumLine.movable){
      if (downy > canvas.height-75){
        malNumLine.movemid();
        context.clearRect(0,0,canvas.width, canvas.height);
        malNumLine.draw("frac");
        if(malNumLine.edit){
          malNumLine.drawZBar();
        }
      }
      if (downx > 5 && downx < 20 && downy > zoompos-25 && downy < zoompos+25){
        malNumLine.moveZBar();
        context.clearRect(0, 0, canvas.width, canvas.height);
        malNumLine.drawZBar();
        malNumLine.draw("frac");
      }
    }
    // activate interest points if we are close to them
  });
  function writeMessage(message){
    context.clearRect(0,0,canvas.width,30);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(message, 10, 25);
  }
  function gcd(num1,num2){
    if (num2==0) {return num1;}
    if (num1 < num2) {return gcd(num2, num1);}
    return gcd(num1-num2, num2);
  }
  function drawNumLine(num, snum, diff, mid){
    var ewid=Math.floor((canvas.width-2*off)/(num*snum));
    var first;
    for (i=center; i >= off; i-=ewid){
      drawLine(i, canvas.height-off, i, canvas.height-off-10);
      first=i;
    }
    var last;
    for (i=center; i <=canvas.width-off; i+=ewid){
      drawLine(i, canvas.height-off, i, canvas.height-off-10);
      last=i;  
    }
    t=mid
      for (i=center; i >= off; i-=ewid*snum){
        drawLine(i, canvas.height-off, i, canvas.height-off-20);
        context.fillText(t, i-5, canvas.height-10)
          t-=diff
      }
    t=0
      for (i=center; i <=canvas.width-off; i+=ewid*snum){
        drawLine(i, canvas.height-off, i, canvas.height-off-20);
        context.fillText(t, i-5, canvas.height-10)
          t+=diff;
      }
    drawLine(first, canvas.height-off, last, canvas.height-off)
  }


  function writeNums(num, x, y){
    context.clearRect(x-5,y,x+5,y+10);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(num, x-7, y+15);
  }


  function drawCircle(x, y, r) {
    context.beginPath();
    context.arc(x, y, r, 0, (2.0 * Math.PI), false);
    context.closePath();
    context.stroke();
  }

  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }

  function Line(x1, y1, x2, y2) {
    Shape.call(this);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.draw = function() {
      drawLine(x1, y1, x2, y2);
    }
    // TODO remove this - it is kind of a hack to make tracingLine work
    this.set_p2 = function(x, y){
      this.x2 = x;
      this.y2 = y;
      this.draw = function() {
        drawLine(this.x1, this.y1, x, y);
      }
    }
    this.underMouse = function() { 
      return false; 
    }
    this.toString = function() {
      return "(Line from " + x1 + ", " + y1 + " to " + x2 + ", " + y2 + ")";
    }
  }

  function addLine(x1,y1,x2,y2) {
    var tmp = new Line(x1,y1,x2,y2);
    return addShape(tmp);
  }
  //
  // Shape Utility Functions
  //
  function distance(x1, y1, x2, y2) {
    xdiff = x1 - x2;
    ydiff = y1 - y2;
    return Math.sqrt(xdiff * xdiff + ydiff * ydiff);
  }
}
//$(setUpNL());  
