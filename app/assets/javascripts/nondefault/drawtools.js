// Drawtools.js
// @author Thomas Ramfjord
// This is a fairly complicated javascript app, so I've written down the basic format.  Basically there is an array of shapes (a 
// shape is basically an interface.  See an example for the functions you need to implement).  The function "redraw" draws all the shapes
// the canvas.  The mouse functions on the canvas element are determined by the "state" variable, which is an index of the STATES array.  
// Each "state" in the array is an object with functions for all the mouse callbacks.  At the intersection of shapes and at the end of lines
// and such are Points Of Interest (POIs), which the mouse will jump to when close enough.
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

  var nextLineNo = 1;   // lines and circles will be given names like l1, l2 - these indicat the number
  var nextCircleNo = 1;
  var startLineNo = 1;  // starting number - set by getStartShapes
  var startCircleNo = 1;
  var COLORS = ["green", "blue", "purple", "red", "orange", "yellow"]

  // state information
  var PROTRACTOR = 0;
  var COMPASS    = 1;
  var RULER      = 2;
  var LINE       = 3;
  var BLANK      = 4;
  var state;          // determines mousedown/up/move effects of canvas - currently represents either
  //  protractor, compass, ruler, or line drawing

  var startShapes = []; // will contain the starting shapes that are not to be deleated on clear()
  var shapes = [];      // will hold the current list of shapes - reset to startShapes on clear()

  // array of POI objects, set with the function updatePOIs()
  var pointsOfInterest = [];
  var activePOI_i = -1; // index of the active POI, -1 indicates none active

  //
  // Drawing/Utility Functions
  //
  function redraw(){
    context.clearRect(0,0,canvas.width, canvas.height);

    if(activePOI_i >= 0) { 
      pointsOfInterest[activePOI_i].draw(); 
    }
    //for (var i = 0; i < pointsOfInterest.length; i++) {
    //  pointsOfInterest[i].draw();
    //}

    for (var i = 0; i < shapes.length; i++) {
      shapes[i].draw();
    }

    //writeMessage(message);
    //writeShapes();
  }

  function setMouseXY(e) {
    var offset = $('#canvas').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);
      
    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
  }
  function writeMessage(message){
    context.clearRect(0,0,canvas.width,30);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(message, 10, 25);
  }
  function writeShapes(){
    var s = "";
    var hidden_s = "";
    var color_i = 0;
    for(var i = 0; i < shapes.length; i++) {
      if(!shapes[i].hidden) {
        //if(i == startShapes.length) { s += "<hl>" }
        s += "<div class=shape style=\"background-color:"+COLORS[i]+";\" id=s_" + i + " >" 
                + shapes[i] + 
             "</div>\n";
        hidden_s += ","+shapes[i].encode();
      }
    }
    //for(var i = 0; i < pointsOfInterest.length; i++) {
    //  s += "<p>" + pointsOfInterest[i] + "</p>\n";
    //}
    shapesDisp.html(s);
    $('#geometry').attr('value', hidden_s.substr(1));

    // add callbacks for colors
    for(var i = 0; i < shapes.length; i++) {
      if(!shapes[i].hidden) {
        $('#s_'+i).mouseenter({i:i, color:COLORS[i]}, function(e) {
          shapes[e.data.i].highlight(e.data.color);
          redraw();
        });
        $('#s_'+i).mouseleave({i:i}, function(e) {
          shapes[e.data.i].unhilight();
          redraw();
        });
      }
    }
    
  }
  function getStartShapes(){
    startShapes = [];
    var s = $('#startshapes').attr('value');
    var a = s.split(',');
    for(var i = 0; i < a.length; i++) {
      addShape(decodeShape(a[i]));
    }

    startLineNo = nextLineNo;
    startCircleNo = nextCircleNo;
    startShapes = shapes.slice(0);
    clear();
  }

  function getActivePOIs() {
    // NOTE I do not redraw - you must call redraw afterwards if you want my effects to be visible
    // if there is an active POI, check if we're still within range
    if(activePOI_i >= 0) {
      if(pointsOfInterest[activePOI_i].mouseDist() > 10) {
        activePOI_i = -1;
        if(state == protState) {
          protractor.toOffset();
        }
      }
    }

    // otherwise activate any POI within range
    else {
      for (var i = 0; i < pointsOfInterest.length; i++) {
        if(pointsOfInterest[i].mouseDist() < 7) {
          activePOI_i = i;
        }
      }
    }
  }
  function updatePOIs() {
    pointsOfInterest = [];

    // individual shape POIs
    for(var i = 0; i < shapes.length; i++) {
      if(shapes[i].hidden) { continue; }

      if(shapes[i] instanceof Line) {
        addPOI(shapes[i].x1, shapes[i].y1);
        addPOI(shapes[i].x2, shapes[i].y2);
      }

      if(shapes[i] instanceof Circle) {
        addPOI(shapes[i].x, shapes[i].y);
      }
    }

    // shape intersection POIs
    for(var i = 0; i < (shapes.length -1); i++) {
      for(var j = i+1; j < shapes.length; j++) {
        if(shapes[i].hidden || shapes[j].hidden) { continue; }

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
    // flip x and y when the slope is close to vertical - this leads to more precise calculations
    // and avoids failure on the vertical case
    var flipped = Math.abs(l.x2 - l.x1) < Math.abs(l.y2 - l.y1);
    var x1 = flipped ? l.y1 : l.x1;
    var y1 = flipped ? l.x1 : l.y1;
    var x2 = flipped ? l.y2 : l.x2;
    var y2 = flipped ? l.x2 : l.y2;
    var xc = flipped ? c.y : c.x;
    var yc = flipped ? c.x : c.y;

    var m = (y2 - y1)/(x2 - x1);
    var b = y1 - m*x1;
    // (x-xc)^2 + (y-yc)^2 = c.r^2                                     CIRCLE
    // y = m(x - x1) + y1                                              LINE
    // (x-xc)^2 + (m(x - x1) + y1 - yc)^2 = c.r^2                      SUB Y
    var tmp = y1 - yc - m*x1; 
    // (x-xc)^2 + (mx + tmp)^2 = c.r^2                                 SUB tmp
    // x^2 - 2x*xc + xc^2 + (mx)^2 + 2*tmp*mx + tmp^2 = c.r^2          EXPAND
    // (m^2+1) x^2 + (2*tmp*m - 2*xc) x + (tmp^2 + xc^2 - c.r^2) = 0   REARRANGE
    var a = m*m + 1;
    var b = 2*tmp*m - 2*xc;
    var c = tmp*tmp + xc*xc - c.r*c.r;

    var discriminant = b*b - 4*a*c;
    //alert("discriminant = " + discriminant);
    //alert("se:  a = " + a + ", b = " + b + ", c = " + c + ", disc = " + discriminant + "\n" +
    //      "m = " + (y2 - y1) + "/" + (x2 - x1) + " = " + m + (flipped ? ", flipped" : ""));
    if(discriminant < 0) { // indicates no intersection even on infinite line
      return 0;
    }
    var maxX = Math.max(x1, x2);
    var maxY = Math.max(y1, y2);
    var minX = Math.min(x1, x2);
    var minY = Math.min(y1, y2);

    discriminant = Math.sqrt(discriminant);
    var x_poi = Math.floor((discriminant - b)/(2 * a));
    var y_poi = Math.floor(m*(x_poi - x1) + y1);
    if(minX <= x_poi && x_poi <= maxX && minY <= y_poi && y_poi <= maxY){
      if(flipped){ addPOI(y_poi, x_poi); } else { addPOI(x_poi, y_poi); }
    }
    if(discriminant == 0) { return 1; }

    x_poi = Math.floor((0 - b - discriminant)/(2 * a));
    y_poi = Math.floor(m*(x_poi - x1) + y1);
    if(minX <= x_poi && x_poi <= maxX && minY <= y_poi && y_poi <= maxY){
      if(flipped){ addPOI(y_poi, x_poi); } else { addPOI(x_poi, y_poi); }
    }
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

  function clearMessage(){
    writeMessage("");
  }

  function drawCircle(x, y, r, color, width) {
    if(color != undefined) { context.strokeStyle = color }
    if(width != undefined) { context.lineWidth = width }
    else { context.lineWidth = 1; }

    context.beginPath();
    context.arc(x, y, r, 0, (2.0 * Math.PI), false);
    context.closePath();
    context.stroke();
  }

  function drawLine(x1,y1, x2, y2, color, width) {
    if(color != undefined) { context.strokeStyle = color; }
    if(width != undefined) { context.lineWidth = width }
    else { context.lineWidth = 1; }
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
  function decodeShape(s) {
    var a = s.split(":");
    var type = a.shift();
    if(type == "line"){
      for(var i = 0; i < a.length; i++) { a[i] = parseInt(a[i]); }
      return new Line(a[0], a[1], a[2], a[3]);
    }
    else if(type == "circle"){
      return new Circle(parseInt(a[0]), parseInt(a[1]), parseFloat(a[2]));
    }
  }

  function updateShapePeriphery() {
    writeShapes();
    updatePOIs();
    redraw();
  }
  function addShape(shape) {
    if(shape instanceof Line){
      nextLineNo++;
    }
    if(shape instanceof Circle){
      nextCircleNo++;
    }

    shapes.push(shape);
    updateShapePeriphery();
    return shapes.length;
  }
  function delShape(shape_i) {
    shapes.splice(shape_i,1);
    updateShapePeriphery();
  }
  function clear() {
    nextLineNo = startLineNo;
    nextCircleNo = startCircleNo;

    shapes = startShapes.slice(0);
    updateShapePeriphery();
  }

  function Line(x1, y1, x2, y2) {
    Shape.call(this);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.num = nextLineNo;

    this.draw = function() {
      drawLine(x1, y1, x2, y2, "black");
    }
    this.highlight = function(color) { 
      this.draw = function() { drawLine(x1, y1, x2, y2, color, 3); }
    }
    this.unhilight = function() { 
      this.draw = function() { drawLine(x1, y1, x2, y2, "black"); }
    }
    // TODO remove this - it is kind of a hack to make tracingLine work
    this.set_p2 = function(x, y){
      this.x2 = x;
      this.y2 = y;
      this.draw = function() {
        drawLine(this.x1, this.y1, x, y, "black");
      }
    }
    this.underMouse = function() { 
      return false; 
    }
    this.toString = function() {
      //return "(Line from " + x1 + ", " + y1 + " to " + x2 + ", " + y2 + ")";
      return "L<sub>" + this.num + "</sub>"
    }
    this.encode = function() {
      return "line:"+this.x1+":"+this.y1+":"+this.x2+":"+this.y2;
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
    this.num = nextCircleNo;

    this.draw = function() {
      drawCircle(this.x, this.y, this.r, "black");
    }
    this.highlight = function(color) {
      this.draw = function() { drawCircle(this.x, this.y, this.r, color, 3); }
    }
    this.unhilight = function() {
      this.draw = function() { drawCircle(this.x, this.y, this.r, "black", 1); }
    }
    this.underMouse = function() { 
      return insideCircle(this.x, this.y, this.r);
    }
    this.toString = function() {
      //return "(Circle " + x + ", " + y + ", " + r.toFixed(3) + ")"; //round of radius to 3 digs
      return "C<sub>"+this.num+"</sub>";
    }
    this.encode = function() {
      return "circle:"+this.x+":"+this.y+":"+this.r;
    }
  }

  // creates a new circle, adds it to shapes, returns new index
  function addCircle(x,y,r) {
    tmp = new Circle(x,y,r);
    return addShape(tmp);
  }

  // Interest Point stuff
  function POI(x, y) {
    this.x = x;
    this.y = y;
    this.active = false;

    this.mouseDist = function() {
      if(state == protState){
        if(!protState.mouse_is_down) {
          return 1024; // hopefully a bigger distance than we'll ever be testing for
        }
        return distance(this.x, this.y, mousex - protractor.offx, mousey - protractor.offy);
      }
      else {
        return distance(this.x,this.y,mousex,mousey);
      }
    }

    this.toString = function() {
      //TODO remove mousedist
      return "(POI " + this.x+", " + this.y + ", " + this.mouseDist();
    }

    this.draw = function() { 
      context.beginPath();
      context.arc(this.x, this.y, 10, 0, (2.0 * Math.PI), false);
      context.closePath();
      context.fillStyle = "green";
      context.fill();
    }
  }
  function addPOI(x, y) {
    pointsOfInterest.push(new POI(x,y));
  }

  // unique shapes
  var protractor = {
    x : canvas.width / 2,
    y : canvas.height / 2,
    offx : 0,
    offy : 0,
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
    },
    setOffset : function () {
      this.offx = mousex - this.x;
      this.offy = mousey - this.y;
    },
    toOffset : function () {
      this.x = mousex - this.offx;
      this.y = mousey - this.offy;
    }
  }

  //
  // App State/Tool definitions
  //
  function setState(newstate) {
    if(state == STATES[newstate]) { return; }
    $('#tools div').removeClass("selected");
    $(STATEIDS[newstate]).addClass("selected");
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
      this.on_protractor = protractor.underMouse();
      if(!this.on_protractor) {
        protractor.setLasttheta();
      }
      else {
        protractor.setOffset();
      }
    },
    mouseup : function() {
      this.mouse_is_down = false;
    },
    mousemove : function() {
      if(this.mouse_is_down){
        if(this.on_protractor){
          protractor.move();
        }
        else {
          protractor.rotate()
        }
      }
    }
  }

  var nullfunc = function() { return null; }

  // when we are in compState, we are using the compass to draw circles
  var compState = {
    tool : "compass",
    mouse_is_down : false,
    usingsetradius : false,
    minicircle_i : -1,

    useWrittenSize : function() {
      $("#compass span").attr("style","");
      $('#compass span').text("Compass R = " + Math.round(parseFloat($("#circlesize").attr("value")),2));
      $('#circlesize').hide();
    },
    useMakeSize : function() {
      $("#compass span").attr("style","border-right:2px solid black;");
      $('#compass span').text("Compass");
      $('#circlesize').show();
    },

    activate : function() {
      $('#usecirclesize').prop("checked", false);
      $('#circlesize').attr("value", "");
      $('#usecirclesize').show();
      this.useMakeSize();
    },
    deactivate : function() {
      $(STATEIDS[COMPASS]+" span").attr("style","");
      $("#compass span").text("Compass");
      $('#circlesize').hide();
      $('#usecirclesize').hide();
    },
    mousedown : function() {
      if(!this.usingSetRadius()) {
        this.mouse_is_down = true;
        tracingLine.start();
        var miniCircle = new Circle(mousex, mousey, 5);
        miniCircle.hidden = true;
        this.minicircle_i = shapes.push(miniCircle);
      }
    },
    mouseup : function() {
      // TODO rm
      if(this.usingsetradius){
        var radius = parseFloat($('#circlesize').attr("value"));
        if(isNaN(radius) || radius < 0.0 || 1000 < radius) {
          alert('"' + $('#circlesize').attr("value") + '" is an invalid circle radius - it has to be a number between 0 and 1000');
          return;
        }
      }
      else {
        shapes.pop(); // minicircle
        var radius = tracingLine.clear();
      }
      addCircle(downx, downy, radius);
      redraw();
      this.mouse_is_down = false;
      $('#circlesize').attr("value", ''+radius);
    },
    mousemove : function() {
      if(this.mouse_is_down && (!this.usingsetradius)) {
        var radius = distance(mousex, mousey, downx, downy);
        //message = "center: ("+downx+", "+downy+"), radius:"+radius;
        tracingLine.follow();
      }
      else {
        //message = "center: ("+mousex+", "+mousey+")";
      }
      //writeMessage(message);
    },
    usingSetRadius : function() {
      this.usingsetradius = $('#usecirclesize:checked').length == 1;
      return this.usingsetradius;
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
      //writeMessage(message);
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

  // array of state objects - each has at least 5 methods: activate, deactivate, mouseup, mousedown, mousemove 
  var STATES = [protState, compState, rulerState, lineState, blankState];
  var STATEIDS = ["#protractor", "#compass", "#ruler", "#line", "#blank"]

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
    activePOI_i = -1;
    redraw();
  });

  $('#canvas').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    setMouseXY(e);

    // activate interest points if we are close to them
    getActivePOIs();
    if(activePOI_i >= 0) {
      if(state == protState) {
        protractor.x = pointsOfInterest[activePOI_i].x;
        protractor.y = pointsOfInterest[activePOI_i].y;
      }
      else {
        mousex = pointsOfInterest[activePOI_i].x;
        mousey = pointsOfInterest[activePOI_i].y;
      }
    }
    state.mousemove();
    redraw();
  });

  $('#compass').click(function(){
    setState(COMPASS);
  });

  function validateCircleSize() {
    var radius = parseFloat($('#circlesize').attr("value"));
    if(isNaN(radius) || 0 >= radius) {
      alert("The radius on the right needs to be a positive number!");
      $('#usecirclesize').prop("checked", false);
      return false;
    }
    if(radius > 500) {
      alert("Hey, that's a pretty big radius.  I don't think it will fit on the screen");
      $('#usecirclesize').prop("checked", false);
      return false;
    }
    return true;
  }
  $('#usecirclesize').click(function() {
    if($('#usecirclesize').prop("checked")){
      if(validateCircleSize()){
        compState.useWrittenSize();
      }
    } else {
      compState.useMakeSize();
    }
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
    clear();
  });

  function a_to_s(arr) {
    s = "";
    for(var i = 0; i < arr.length; i++) {
      s += arr[i] + "\n";
    }
    return s;
  }

  //
  // general/main part
  //
  //addLine(600, 0, 600, canvas.height);
  //alert(STATES[0].tool + ", " + STATES[1].tool);
  getStartShapes();
  setState(COMPASS);
});
