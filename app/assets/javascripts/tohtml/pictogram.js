function drawimage2(a,n,m,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  // alert("canvaswidth is"+canvaswidth+"blah"+a);
  var ycord = y;
  var xcord = x;
for (var i = 0; i < n+(m/2)-(m%2); i++) 
{
  // alert(""+i);
  if (xcord+distance+width<canvaswidth) 
  {
  ctx.drawImage(image1,xcord,ycord,width,height);
   xcord = xcord+(distance+width);
  }
  else
  {
    xcord = x;
    ycord = ycord+distance+height;
  ctx.drawImage(image1,xcord,ycord,width,height);
   xcord = xcord+(distance+width);
  }
}

for(var i =0; i<m%2; i++)
{

  if (xcord+distance+(width/2)<canvaswidth)
  { 
  ctx.drawImage(image2,xcord,ycord,width/2,height);
  xcord = xcord+(distance+(width/2));
  }
  else
  {
    xcord = x;
    ycord = ycord+distance+height;
    ctx.drawImage(image2,xcord,ycord,width/2,height);
    xcord = xcord+(distance+(width/2));
  }
}
}
function drawimage3(a,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  // alert("canvaswidth is"+canvaswidth);

  // alert("blah"+x+y+width+height+distance+"fck"+xcordinate[a]);
  if ((no1[a]==0)&&(no2[a]==0)) 
  {
     xcordinate[a] = x;
     ycordinate[a] = y;
  // alert("blah"+x+y+width+height+distance+"fck"+xcordinate[a]);

     ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a] +(width+distance); 
  }
  else
  {
  // alert("blahh"+x+y+width+height+distance+"fck"+xcordinate[a]);

    if (xcordinate[a]+distance+width<canvaswidth)
    { 
      ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a] +(width+distance);
    }
    else
    {
      xcordinate[a] = x;
      ycordinate[a] = ycordinate[a]+distance+height;
      ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a]+(distance+width);
    }

  }
  no1[a]=no1[a]+1;
  no[a]=no[a]+1;
  putvalue2(a,no[a]);
}
function drawimage4(a,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  if ((no1[a]==0)&&(no2[a]==0))  
  {
     xcordinate[a] = x;
     ycordinate[a] = y;
     ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a] +(width/2+distance); 
  }
  else
  {
    if (xcordinate[a]+distance+width<canvaswidth)
    { 
      ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a] +(width/2+distance);
    }
    else
    {
      xcordinate[a] = x;
      ycordinate[a] = ycordinate[a]+distance+height;
      ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a]+(distance+width/2);
    }

  }
  no2[a]=no2[a]+1;
  no[a]=no[a]+0.5; 
  putvalue2(a,no[a]);
}


function putvalue2(a,sliceno)
{
  var a  =a;                
  // alert("slice number is " + sliceno+"a= "+a);
  var sliceno=sliceno;
  $("#pictogram_table"+" tr:eq("+a+")").find("input").attr("value", sliceno); 
}                