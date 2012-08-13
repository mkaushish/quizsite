function weightMeasure(cname, name, object, unit, weight){
  var canvas = $('#'+cname)[0];
  var context = canvas.getContext('2d');
  var wts=[];
  var leftwt = weight;
  var rightwt = 0;
  var wtstr=weight.toString();
  wtstr=wtstr.split("").reverse().join("");
  for(i=0; i < wtstr.length; i++){
    wts[i]=parseInt(wtstr[i]);
  }
  var mg = 20;
  var fht = 50;
  var lth = 300;
  var iangle = Math.acos(fht/lth);
  var angle=iangle;
  function fillTri(x1, y1, x2, y2, x3, y3){
    context.beginPath();
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.lineTo(x3, y3);
    context.lineTo(x1, y1);
    context.closePath();
    context.fillStyle="blue";
    context.fill();
  } 
  function drawFulcrum(){
    fillTri(context.width/2-20, context.height-mg, context.width/2+20, context.height-mg, context.width/2, context.height-20-fht);
  }
  function setAngle(){
    angle=2*Math.PI*rightwt/leftwt;
    if(angle < iangle) {angle=iangle;}
    if(angle > Math.PI-iangle) {angle=Math.PI-iangle;}
  }
  function drawLever(){
    context.save();
    context.translate(context.width/2, context.height-fht-20-10);
    context.rotate(angle);
    context.fillStyle="gray";
    context.fillRect(-5, -lth/2, 10, lth);
  }
  drawFulcrum();
  setAngle();
  drawLever();
}
