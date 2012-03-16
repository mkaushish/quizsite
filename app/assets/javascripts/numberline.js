
$(function() {
  // global drawing variables
  var canvas = $('#canvas')[0];
  var shapesDisp = $('#shapes');
  var messageDisp = $('#message');
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var off=25;         // offset from edges
  var center=(context.width)/2; 
  

  function drawNumLine(num, snum){
    var ewid=(width-2*off)/(num*snum);
    var first;
    for (i=center; i >= off; i-=ewid){
      drawLine(i, context.height-off, i, context.height-off-20);
      first=i;
    }
    var last;
    for (i=center; i <=context.width-off; i+=ewid){
      drawLine(i, context.height-off, i, context.height-off-20);
      last=i;  
    }
    for (i=center; i >= off; i-=ewid*snum){
      drawLine(i, context.height-off, i, context.height-off-20);
    }
    for (i=center; i <=context.width-off; i+=ewid*snum){
      drawLine(i, context.height-off, i, context.height-off-20);
    }
    drawLine(first, context.height-off, last, context.height-off)
  }


  function writeMessage(message){
    context.clearRect(0,0,canvas.width,30);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(message, 10, 25);
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
