function createshape(a,par4,par5,par6,par7)
{
	// alert("shape is" +a);
	if(a=='circle')
	{	
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 	}
 	else if(a=='rectangle1')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else if(a=='rectangle2')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else if(a=='rectangle3')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else
	{
		alert("futre vu");
	}
}


function slice(par1,par2,par3,par4,par5,par6,par7,arr,choose)
{	
	if(par1=='circle')
	{	
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		var angle = par2;
		var b = 360.0/angle;
		var a = (angle/180.0)*Math.PI;
		var c = a;
		// alert("no of slices " + b);
		for(var i =0;i<b;i++)
		{
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,0,c);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			c  = c+a;
			colored[i]=0;
		}
		c = a;
		for(var i =0;i<b;i++)
		{
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,0,c);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "black";
			ctx.closePath();
			ctx.stroke();
			c  = c+a;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
           	var d= (sliceno-1)*a;
           	var e = d+a;
           	ctx.beginPath();
			ctx.arc(centrex,centrey,radius,d,e);
			ctx.lineTo(centrex,centrey);
			ctx.stroke();
			ctx.fillStyle = "red";
			ctx.fill();
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,d,e);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "black";
			ctx.closePath();
			ctx.stroke();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle1')
	{	
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len  = par2;
		var a = length/len;
		// alert("no of slices " + a);
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		var e = startx;
		for(var i =0; i<a; i++)
		{
			ctx.beginPath();
			ctx.moveTo(e,starty);
			ctx.lineTo(e+len,starty);
			ctx.lineTo(e+len,starty+breadth);
			ctx.lineTo(e,starty+breadth);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			e = e+len;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			var d= (sliceno-1)*len;
           	var e = startx+d;
           	ctx.beginPath();
           	ctx.moveTo(e,starty);
			ctx.lineTo(e+len,starty);
			ctx.lineTo(e+len,starty+breadth);
			ctx.lineTo(e,starty+breadth);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle2')
	{
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len = par2;
		var a = breadth/len;
		// alert("no of slices " + a);
		ctx.beginPath();
		ctx.rect(startx,starty,length,length);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		var e = starty;
		for(var i =0; i<a; i++)
		{
			ctx.beginPath();
			ctx.moveTo(startx,e);
			ctx.lineTo(startx,e+len);
			ctx.lineTo(startx+length,e+len);
			ctx.lineTo(startx+length,e);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			e = e+len;
			colored[i]=0;
		}
		alert("alert");
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			var d= (sliceno-1)*len;
			var e = starty+d;
            ctx.beginPath();
           	ctx.moveTo(startx,e);
			ctx.lineTo(startx,e+len);
			ctx.lineTo(startx+length,e+len);
			ctx.lineTo(startx+length,e);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle3')
	{
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len = par2;
		var bre = par3;
		var a = length/len;
		var b = breadth/bre;
		// alert("no of slices " + a*b);
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill;
		var x = startx;
		var y =starty;
		for(var i =0; i<a; i++)
		{
		 	y =starty;
			for(var j=0;j<b;j++)
			{
			// alert("blah");
				ctx.beginPath();
				ctx.moveTo(x,y);
				ctx.lineTo(x,y+bre);
				ctx.lineTo(x+len,y+bre);
				ctx.lineTo(x+len,y);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				y = y+bre;
			}
			x = x+len;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			// sliceno = (len*(slicex-1))+slicey;
			var slicey = sliceno%len;
			var slicex = ((sliceno-slicey)/len)+1;
			var locx= (slicex-1)*len+startx;
            var locy = (slicey-1)*bre+starty;
       		ctx.beginPath();
			ctx.moveTo(locx,locy);
			ctx.lineTo(locx,locy+bre);
			ctx.lineTo(locx+len,locy+bre);
			ctx.lineTo(locx+len,locy);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}
		}
	}
}

function update(event,par1,par2,par3,par4,par5,par6,par7) 
{	if(par1=='circle')
	{
		 // alert("circle");
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		var angle = par2;
		// alert("angle="+angle);
		// var rect = c.getBoundingClientRect();
		var b = 360.0/angle;
		var a = (angle/180.0)*Math.PI;
		var sliceno = 1;
		var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-centrex;	
        var pageY=event.pageY-offsety-centrey;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
        
         // alert("coordinates are  "+ pageX +"and"+pageY);
        var tanangle = pageY/pageX;
        var angle2 = Math.atan(pageY/pageX);
             // alert("angle is " + angle2);
        var angle3 = (angle2*180)/Math.PI;
            // alert("angle in degrees is " + angle3);
        if (((pageX*pageX)+(pageY*pageY))<(radius*radius))
            {
           		if (pageY>0)
           			if (angle3>0) 
           			{
           				sliceno += Math.floor(angle3/angle);
           			}
           			else
           			{
           				sliceno += Math.floor((angle3+90)/angle) + Math.floor(90/angle);
           			}
           		else
           			if (angle3>0) 
           			{
           				sliceno += Math.floor((angle3)/angle) + Math.floor(180/angle);
           			}
           			else
           			{
           				sliceno += Math.floor((angle3+90)/angle) + Math.floor(270/angle);
           			}
           			alert("slice number is " + sliceno);
           			var d= (sliceno-1)*a;
           			var e = d+a;
           			if (colored[sliceno-1]==1) 
           			{
           				ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.stroke();
						ctx.fillStyle = "green";
						ctx.fill();
						ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.strokeStyle = "black";
						ctx.closePath();
						ctx.stroke();
						colored[sliceno-1]=0;
						putvalue(sliceno);
					}
					else
					{
           				ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.stroke();
						ctx.fillStyle = "red";
						ctx.fill();
						ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.strokeStyle = "black";
						ctx.closePath();
						ctx.stroke();
						colored[sliceno-1]=1;
						putvalue(sliceno);
					}

       		}
       		else
       		{
       			alert("outside the circle");
       		}
    }
    else if (par1=='rectangle1')
    {	
    	// alert("rectangle1");
    	var len = par2;
		var sliceno = 1;
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
            // alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	sliceno += Math.floor(pageX/len);
            	alert("sliceno is " +sliceno);
            	var d= (sliceno-1)*len;
           		var e = startx+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
           		ctx.moveTo(e,starty);
				ctx.lineTo(e+len,starty);
				ctx.lineTo(e+len,starty+breadth);
				ctx.lineTo(e,starty+breadth);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
           		ctx.moveTo(e,starty);
				ctx.lineTo(e+len,starty);
				ctx.lineTo(e+len,starty+breadth);
				ctx.lineTo(e,starty+breadth);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);
				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
	else if(par1=='rectangle2')
	{
		// alert("rectangle2");
		var len = par2;
		var sliceno = 1;
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
             alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	sliceno += Math.floor(pageY/len);
            	alert("sliceno is " +sliceno);
            	var d= (sliceno-1)*len;
           		var e = starty+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
           		ctx.moveTo(startx,e);
				ctx.lineTo(startx,e+len);
				ctx.lineTo(startx+length,e+len);
				ctx.lineTo(startx+length,e);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
           		ctx.moveTo(startx,e);
				ctx.lineTo(startx,e+len);
				ctx.lineTo(startx+length,e+len);
				ctx.lineTo(startx+length,e);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);

				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
	else if(par1=='rectangle3')
	{
		// alert("rectangle3");
		var len = par2;
		var bre = par3;
	    var sliceno = 1;
		var slicex = 1;
		var slicey =1;
        var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
            // alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	slicey += Math.floor(pageY/bre);
            	slicex += Math.floor(pageX/len);
            	sliceno = (len*(slicex-1))+slicey;
            	alert("sliceno is " +sliceno);
            	var locx= (slicex-1)*len+startx;
            	var locy = (slicey-1)*bre+starty;
    //         	var d= (sliceno-1)*len;
    //        		var e = 150+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
				ctx.moveTo(locx,locy);
				ctx.lineTo(locx,locy+bre);
				ctx.lineTo(locx+len,locy+bre);
				ctx.lineTo(locx+len,locy);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
				ctx.moveTo(locx,locy);
				ctx.lineTo(locx,locy+bre);
				ctx.lineTo(locx+len,locy+bre);
				ctx.lineTo(locx+len,locy);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);
				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
}


function putvalue(sliceno)
{
                	// alert("#shapetable"+" tr:eq("+sliceno+")");
                	// alert("slice number is " + sliceno);
                      var sliceno=sliceno-1;
                      $("#shapetable"+" tr:eq("+sliceno+")").find("input").attr("value", colored[sliceno]); 
                      // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
} 