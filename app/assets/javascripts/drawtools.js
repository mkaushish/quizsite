// This is a fairly complicated javascript app, so I've written down the basic format.  Basically there is an array of shapes (a 
// shape is basically an interface.  See an example for the functions you need to implement).  The function "redraw" draws all the shapes
// the canvas.  The mouse functions on the canvas element are determined by the "state" variable, which is an index of the STATES array.  
// Each "state" in the array is an object with functions for all the mouse callbacks.
//
//  section 1:
//      global variables and constants.  Constants should be all caps.
//    shapes: the variable which contains all the shapes
//
//  section 2:
//      drawing/utility functions.  Here you will find functions to write output like messages, and various utility functions used
//      elsewhere in the code.  Odds and ends can go here.
//    redraw: I redraw all the shapes and write messages and stuff.
//    updatePOIs: goes through each pair of shapes, and adds points of interest where they intersect
//      -poiBlahBlah functions are for finding intersections between a pair of shapes and adding POI's for them
//
//  section 3:
//      -shape utility functions
//      -generic shape definitons (eg. circle, line)
//      -specific shape definitions (eg. protractor)
//
//  section 4:
//      -state definitions (eg. compassState, rulerState, etc)
//
//  section 5:
//      -essentially the main method type code - If you want to draw things on load do it here.

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

  // state information
  var PROTRACTOR = 0;
  var COMPASS    = 1;
  var RULER      = 2;
  var LINE       = 3;
  var BLANK      = 4;
  var state;          // determines mousedown/up/move effects of canvas - currently represents either
  //  protractor, compass, ruler, or line drawing

  // shape informtion
  var CIRCLE = 1;
  //var LINE = 3; yeah I'm doubling down on this constant, see above definition
//    

  // array of shape objects - each has at least 5 methods: activate, deactivate, mouseup, mousedown, mousemove oh also underMouse might be nice... maybe
  // TODO doc better shape interface/abstract class - maybe even make it a superclass/prototype here
  var shapes = [];
  var pointsOfInterest = [];
  var noshape = null;

  //
  // Drawing/Utility Functions
  //
  function redraw(){
    context.clearRect(0,0,canvas.width, canvas.height);
    for (var i = 0; i < shapes.length; i++) {
      shapes[i].draw();
    }
    for (var i = 0; i < pointsOfInterest.length; i++) {
      pointsOfInterest[i].draw();
    }

    // TESTING TODO REMOVE
    //message = "mousex = " + mousex + ", mousey = " + mousey;
    //writeMessage(message);
    writeShapes();
  }

  function writeMessage(message){
    context.clearRect(0,0,canvas.width,30);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(message, 10, 25);
  }
  function writeShapes(){
    var s = "";
    for(var i = 0; i < shapes.length; i++) {
      //context.fillText(shapes[i].toString(), (canvas.width-200), (130 + 20 * i));
      if(!shapes[i].hidden) {
        s += "<p>" + shapes[i] + "</p>\n";
      }
    }
    shapesDisp.html(s);
  }

  function updatePOIs() {
    //alert("updatePOIs being called");
    pointsOfInterest = [];
    for(var i = 0; i < (shapes.length -1); i++) {
      for(var j = i+1; j < shapes.length; j++) {
        if(shapes[i].hidden || shapes[j].hidden) {
          continue;
        }

        if(shapes[i] instanceof Circle) {
          if(shapes[j] instanceof Circle) {
            poiCircleCircle(shapes[i], shapes[j]);
          }
          else if(shapes[j] instanceof Line) {
            poiLineCircle(shapes[j], shapes[i]);
          }
        }
        else if(shapes[i] instanceof Line) {
          if(shapes[j] instanceof Circle) {
            poiLineCircle(shapes[i], shapes[j]);
          }
          else if(shapes[j] instanceof Line) {
            poiLineLine(shapes[i], shapes[j]);
          }
        }
      }
    }
  }
  function poiLineLine(l1, l2) {
    var denom = (l1.x1 - l1.x2)*(l2.y1 - l2.y2) - (l1.y1 - l1.y2)*(l2.x1 - l2.x2);
    if(denom == 0) { // lines are parallel
      return 0;
    }
    
    // get the intersection of the lines using a formula given by wikipedia: http://en.wikipedia.org/wiki/Line-line_intersection
    var x = Math.floor(((l1.x1 * l1.y2 - l1.y1 * l1.x2) * (l2.x1 - l2.x2) - (l1.x1 - l1.x2)*(l2.x1 * l2.y2 - l2.y1 * l2.x2)) / denom);
    var y = Math.floor(((l1.x1 * l1.y2 - l1.y1 * l1.x2) * (l2.y1 - l2.y2) - (l1.y1 - l1.y2)*(l2.x1 * l2.y2 - l2.y1 * l2.x2)) / denom);

    // ensure that the intersection is on both line segments
    var maxX = Math.min(Math.max(l1.x1, l1.x2), Math.max(l2.x1, l2.x2));
    var maxY = Math.min(Math.max(l1.y1, l1.y2), Math.max(l2.y1, l2.y2));
    var minX = Math.max(Math.min(l1.x1, l1.x2), Math.min(l2.x1, l2.x2));
    var minY = Math.max(Math.min(l1.y1, l1.y2), Math.min(l2.y1, l2.y2));
    if(minX <= x && x <= maxX && minY <= y && y <= maxY) {
      addPOI(x,y)
    }
  }
  // note that I currently don't return the number of POIs like my friends, or indeed anything useful
  function poiLineCircle(l, c) {
    var m = (l.y2 - l.y1)/(l.x2 - l.x1);
    var b = l.y1 - m*l.x1;
    // (x-c.x)^2 + (y-c.y)^2 = c.r^2                                                  CIRCLE
    // y = m(x - l.x1) + l.y1                                                         LINE
    // (x-c.x)^2 + (m(x - l.x1) + l.y1 - c.y)^2 = c.r^2                               SUB Y
    var tmp = l.y1 - c.y - m*l.x1; 
    // (x-c.x)^2 + (mx + tmp)^2 = c.r^2                                               SUB tmp
    // x^2 - 2x*c.x + c.x^2 + (mx)^2 + 2*tmp*mx + tmp^2 = c.r^2                       EXPAND
    // (m^2+1) x^2 + (2*tmp*m - 2*c.x) x + (tmp^2 + c.x^2 - c.r^2) = 0                REARRANGE
    var a = m*m + 1;
    var b = 2*tmp*m - 2*c.x;
    var c = tmp*tmp + c.x*c.x - c.r*c.r;

    var discriminant = b*b - 4*a*c;
    //alert("discriminant = " + discriminant);
    //alert("se:  a = " + a + ", b = " + b + ", c = " + c + "\n" +
    //      "me:  a = " + a1 + ", b = " + b1 + ", c = " + c1 + "\n" +
    //      "mad: a = " + a2 + ", b = " + b2 + ", c = " + c2 + "\n" +
    //      "m = " + (l.y2 - l.y1) + "/" + (l.x2 - l.x1) + " = " + m);
    if(discriminant < 0) { // indicates no intersection even on infinite line
      return 0;
    }
    var maxX = Math.max(l.x1, l.x2);
    var maxY = Math.max(l.y1, l.y2);
    var minX = Math.min(l.x1, l.x2);
    var minY = Math.min(l.y1, l.y2);

    discriminant = Math.sqrt(discriminant);
    var x1 = Math.floor((discriminant - b)/(2 * a));
    var y1 = Math.floor(m*(x1 - l.x1) + l.y1);
    //if(minX <= x1 && x1 <= maxX && minY <= y1 && y1 <= minY){
      addPOI(x1, y1);
    //}
    if(discriminant == 0) { return 1; }

    var x2 = Math.floor((0 - b - discriminant)/(2 * a));
    var y2 = Math.floor(m*(x2 - l.x1) + l.y1);
    //if(minX <= x1 && x1 <= maxX && minY <= y1 && y1 <= minY){
      addPOI(x2, y2);
    //}
    //alert("x1 = " + x1 + ", y1 = " + y1);
    return 2;
  }
  function poiCircleCircle(c1, c2) {
    var dist = distance(c1.x, c1.y, c2.x, c2.y);
    var overlap = (c1.r + c2.r) - dist;
    if(overlap < 0 || dist == 0) { return 0; } // if no intersections OR circles are same, we don't want POIS
    if(overlap == 0) { 
      var x = (c2.x - c1.x)*(c1.r/(c1.r + c2.r)) + c1.x;
      var y = (c2.y - c1.y)*(c1.r/(c1.r + c2.r)) + c1.y;
      addPOI(x,y);
      return 1;
    }
    
    // we can now assume that there are 2 points of intersection
    // equations taken from http://paulbourke.net/geometry/2circle/
    var a = (c1.r * c1.r - c2.r * c2.r + dist * dist) / (2 * dist); // a =~ distance from c1 to the midpoint between the two circles
    var h = Math.sqrt(c1.r * c1.r - a * a); // 
    // (x,y) is P2 on the url above, which is the main point between the two circles
    var x = (c2.x - c1.x)*(a/dist) + c1.x;
    var y = (c2.y - c1.y)*(a/dist) + c1.y;

    var x1 = x - (h/dist)*(c2.y - c1.y);
    var x2 = x + (h/dist)*(c2.y - c1.y);
    var y1 = y + (h/dist)*(c2.x - c1.x);
    var y2 = y - (h/dist)*(c2.x - c1.x);
    addPOI(x1,y1);
    addPOI(x2,y2);
    return 2;
  }

  // TODO remove...? ugly
  function a_to_s(arr) {
    s = "";
    for(var i = 0; i < shapes.length; i++) {
      s += shapes[i] + "\n";
    }
    return s;
  }

  function clearMessage(){
    writeMessage("");
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

  //
  // Shape Utility Functions
  //
  function distance(x1, y1, x2, y2) {
    xdiff = x1 - x2;
    ydiff = y1 - y2;
    return Math.sqrt(xdiff * xdiff + ydiff * ydiff);
  }
  function getTopShape() {
    // we want to do this in order
    for(var i = 0; i < shapes.length; i++){
      if(shapes[i].underMouse()){
        return shapes[i];
      }
    }
    return noshape;
  }

  function insideCircle(x, y, r) {
    return (distance(x,y, mousex, mousey) <= r)
  }

  //
  // Specific Shape functions/definitions
  //
  function Shape(hidden) {
    hidden = typeof hidden !== 'undefined' ? hidden : false;
    this.hidden = hidden;
    this.color = "Black";
  }

  function addShape(shape) {
    shapes.push(shape);
    writeShapes();
    updatePOIs();
    return shapes.length;
  }
  function delShape(shape_i) {
    shapes.splice(shape_i,1);
    writeShapes();
    updatePOIs();
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

  function Circle(x,y,r) {
    Shape.call(this);
    this.x = x;
    this.y = y;
    this.r = r;
    this.draw = function() {
      drawCircle(this.x, this.y, this.r);
    }
    this.underMouse = function() { 
      return insideCircle(this.x, this.y, this.r);
    }
    this.toString = function() {
      return "(Circle " + x + ", " + y + ", " + r.toFixed(3) + ")"; //round of radius to 3 digs
    }
  }

  // creates a new circle, adds it to shapes, returns new index
  function addCircle(x,y,r) {
    tmp = new Circle(x,y,r);
    return addShape(tmp);
  }

  function POI(x, y) {
    Shape.call(this, true); // the true just makes this hidden to start
    this.x = x;
    this.y = y;
    this.active = false;

    this.toString = function() {
      // TODO this really shouldn't print out in the list of shapes
      // return "";
      return "(POI "+this.x+", "+this.y+", "+ (this.active) ? "":"not " + "active)";
    }

    this.distance = function(x,y) {
      return distance(this.x,this.y,x,y);
    }

    this.draw = function() { 
      //if(this.active) {
        context.beginPath();
        context.arc(this.x, this.y, 10, 0, (2.0 * Math.PI), false);
        context.closePath();
        context.fillStyle = "green";
        context.fill();
      //}
    }
  }
  function addPOI(x, y) {
    pointsOfInterest.push(new POI(x,y));
  }

  // unique shapes
  var protractor = {
    x : canvas.width / 2,
    y : canvas.height / 2,
    theta : 0.0,
    shapes_i : -1,

    lastx : -1,
    lasty : -1,
    lasttheta : 0.0,

    addToShapes : function() {
      if(this.shapes_i >= 0){
        return this.shapes_i;
      }
      else {
        this.shapes_i = shapes.push(this) - 1;
        redraw();
        return this.shapes_i;
      }
    },
    delFromShapes : function() {
      if(this.shapes_i >= 0) {
        shapes.splice(this.shapes_i, 1);
        redraw();
        this.shapes_i = -1;
      }
    },
    toString : function() { 
      return "(Protractor at " + this.x + ", " + this.y + ")";
    },
    move : function() {
      this.x -= this.lastx - mousex;
      this.y -= this.lasty - mousey;
      this.lastx = mousex;
      this.lasty = mousey;
    },
    rotate : function() {
      var mousetheta = Math.atan2((mousex - this.x), (mousey - this.y));
      this.theta -= mousetheta - this.lasttheta;
      this.lasttheta = mousetheta;
      // T?DO? ensure theta is between 0 and PI/2 
    },
    // sets this.lasttheta to the mouse coordinate theta
    setLasttheta : function() {
      this.lasttheta = Math.atan2((mousex - this.x), (mousey - this.y));
    },

    draw : function() {
      var innerRadius = 50;
      var outerRadius = 100;
      var x = this.x;
      var y = this.y;

      // the weird begin/closePath stuff here is to fix a bug with the closing path with lines thing
      context.beginPath();
      // minicircle in the center
      context.arc(this.x, this.y, 5, 0, 2*Math.PI, true);
      context.closePath();
      context.stroke();
      // outer D
      context.beginPath();
      context.arc(this.x, this.y, outerRadius, Math.PI + this.theta, 2*Math.PI + this.theta, false);
      //inner semicircle
      context.arc(this.x, this.y, innerRadius, Math.PI + this.theta, 2*Math.PI + this.theta, false);

      var total = 1;
      var divisors = [2,9,2];
      for (var n = 0; n < divisors.length; n++) {
        total *= divisors[n];
        theta_i = Math.PI / total; // not that theta is the current rotation of the compass
        myInnerRadius = (outerRadius - innerRadius) * n / divisors.length + innerRadius;
        for(var i = 1; i < total; i++) {
          var angle = i * theta_i + this.theta;
          var sine = 0.0 - Math.sin(angle);
          var cosine = 0.0 - Math.cos(angle);
          var x1 = cosine * myInnerRadius + this.x;
          var y1 = sine * myInnerRadius + this.y;
          var x2 = cosine * outerRadius + this.x;
          var y2 = sine * outerRadius + this.y;

          context.moveTo(x1,y1);
          context.lineTo(x2,y2);
        }
      }
      var x1 = Math.cos(this.theta) * outerRadius + this.x;
      var y1 = Math.sin(this.theta) * outerRadius + this.y;
      var x2 = Math.cos(this.theta + Math.PI) * outerRadius + this.x;
      var y2 = Math.sin(this.theta + Math.PI) * outerRadius + this.y;
      context.moveTo(x1,y1);
      context.lineTo(x2,y2);
      //context.closePath();
      context.stroke();
    },
    underMouse : function() {
      // TODO calculate for real
      return insideCircle(this.x, this.y, 100);
    }
  }

  //
  // App State/Tool definitions
  //
  function setState(newstate) {
    if(!(typeof state === "undefined")){
      state.deactivate();
    }

    if(typeof STATES[newstate] === "undefined"){
      alert("undefined newstate: "+ newstate + ", " + a_to_s(STATES));
      state = protState;
    } 
    else {
      state = STATES[newstate];
    }
    state.activate();
  }

  // when we're in protState, we're using the protractor to measure angles
  var protState = {
    tool : "protractor",  
    // variables we need to determine behaviour
    on_protractor : false,
    mouse_is_down : false,

    // methods
    activate : function() {
      protractor.addToShapes();
    },
    deactivate : function() {
      protractor.delFromShapes();
    },

    // mouse actions
    mousedown : function() {
      this.mouse_is_down = true;
      protractor.lastx = downx;
      protractor.lasty = downy;
      topshape = getTopShape();
      this.on_protractor = protractor.underMouse();
      if(!this.on_protractor) {
        protractor.setLasttheta();
      }
    },
    mouseup : function() {
      this.mouse_is_down = false;
    },
    mousemove : function() {
      if(this.mouse_is_down){
        if(this.on_protractor){
          protractor.move();
          redraw(); 
        }
        else {
          // TODO add rotation
          protractor.rotate()
          redraw();
        }
      }
    }
  }

  var nullfunc = function() { return null; }

  // when we are in compState, we are using the compass to draw circles
  var compState = {
    tool : "compass",
    mouse_is_down : false,
    line_i : -1,
    minicircle_i : -1,

    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : function() {
      this.mouse_is_down = true;
      tracingLine.start();
      var miniCircle = new Circle(mousex, mousey, 5);
      miniCircle.hidden = true;
      this.minicircle_i = addShape(miniCircle);
    },
    mouseup : function() {
      // TODO rm
      shapes.pop(); // minicircle
      var radius = tracingLine.clear();
      addCircle(downx, downy, radius);
      redraw();
      this.mouse_is_down = false;
    },
    mousemove : function() {
      if(this.mouse_is_down) {
        var radius = distance(mousex, mousey, downx, downy);
        message = "center: ("+downx+", "+downy+"), radius:"+radius;
        tracingLine.follow();
        redraw();
      }
      else {
        message = "center: ("+mousex+", "+mousey+")";
      }
      writeMessage(message);
    }
  } 

  // state for using a ruler
  var rulerState = {
    mouse_is_down : false,
    x : 0,
    y : 0,
    last_dist : "n/a",

    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : function() {
      this.mouse_is_down = true;
      this.x = mousex;
      this.y = mousey;
      tracingLine.start();
      //addCircle(mousex, mousey, 5);
    },
    mousemove : function() { 
      var message;
      if(this.mouse_is_down) {
        message =  "distance from ("+this.x+", "+this.y+") to (";
        message += mousex+", "+mousey+") = " + distance(this.x,this.y,mousex,mousey);
        tracingLine.follow();
      }
      else {
        message = "(" + mousex + ", " + mousey + "), just measured: " + this.last_dist;
      }
      redraw();
      writeMessage(message);
    },
    mouseup : function() {
      this.mouse_is_down = false;
      //shapes.pop();
      var dist = tracingLine.clear();
      this.last_dist = dist;
      // TODO print out distance in a better way
    }

  }

  // the state for drawing a line / using a straightedge
  var lineState = {
    x1 : mousex,
    y1 : mousey,
    mouse_is_down : false,

    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : function() {
      this.mouse_is_down = true;
      this.x1 = mousex;
      this.y1 = mousey;
      tracingLine.start();
    },
    mouseup : function() {
      this.mouse_is_down = false;
      tracingLine.clear();
      addLine(this.x1, this.y1, mousex, mousey);
      redraw();
    },
    mousemove : function() {
      var message;
      // TODO this is copypasted from rulerState, so I should extrapolate this somehow if I return here
      if(this.mouse_is_down) {
        message =  "distance from ("+this.x1+", "+this.y1+") to (";
        message += mousex+", "+mousey+") = " + distance(this.x1,this.y1,mousex,mousey);
        tracingLine.follow();
      }
      else {
        message = "center: ("+mousex+", "+mousey+")";
      }
      // TODO somehow need to write this message on mouseup as well
      writeMessage(message);
    }
  }

  // state we start in
  var blankState = {
    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : nullfunc,
    mouseup : nullfunc,
    mousemove : nullfunc
  }

  var STATES = [protState, compState, rulerState, lineState, blankState];

  // a helper state for those which want a tracing line on mouse pushdown
  var tracingLine = {
    shape_i : -1,
    start : function() {
      if(this.shape_i < 0) {
        var line = new Line(mousex, mousey, mousex+1, mousey+1);
        line.hidden = true;
        this.shape_i = shapes.push(line) - 1;
      }
    },
    follow : function() {
      shapes[this.shape_i].set_p2(mousex, mousey);
      //context.fillText(shapes[i].toString(), (canvas.width-200), 500);
      redraw();
    },
    clear : function() {
      line = shapes[this.shape_i];
      var dist = distance(line.x1, line.y1,line.x2, line.y2);
      shapes.splice(this.shape_i,1);
      this.shape_i = -1
        redraw();
      return dist;
    }
  }

  //
  // Callbacks for mouse gestures
  //
  $('#canvas').mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    state.mousedown();
  });

  $('#canvas').mouseup(function (e) { 
    state.mouseup();
  });

  $('#canvas').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    mousex = e.pageX - this.offsetLeft;
    mousey = e.pageY - this.offsetTop;
    state.mousemove();
  });

  $('#compass').click(function(){
    setState(COMPASS);
  });

  $('#protractor').click(function(){
    setState(PROTRACTOR);
  });

  $('#ruler').click(function(){
    setState(RULER);
  });

  $('#line').click(function(){
    setState(LINE);
  });

  $('#clear').click(function(){
    shapes = [];
    redraw();
  });

  //
  // general/main part
  //
  //addLine(600, 0, 600, canvas.height);
  //alert(STATES[0].tool + ", " + STATES[1].tool);
  mycircle = new Circle(200,200,60);
  mycircle2 = new Circle(300,300,60);
  
  shapes = [mycircle] ;
  setState(COMPASS);
  addLine(20,50, 300,300);
  redraw();
});
