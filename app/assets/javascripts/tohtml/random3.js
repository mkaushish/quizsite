function createshape1(a,par1,par2,par3,par4,par5,unit)
{
	// alert("shape is" +a);
	if(a=='circle')
	{	
		var centrex = par2*5;
		var centrey =par3*5;
		var radius = par1*5;
		var choice= par4;
		var unit = unit;
		
		// ctx.rotate(40*Math.PI/180);
		if (choice==0)
		{
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(centrex+radius,centrey);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		// alert("radius is " +unit);
  		// ctx.fillText("radius = "+radius/5+""+unit, centrex+5, centrey-5);
  		}
  		else
  		{
  			ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(centrex+radius,centrey);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		// alert("radius is " +unit);
  		ctx.fillText("radius = "+radius/5+""+unit, centrex+5, centrey-5);
  		}
 	}
 	else if (a=='arc_1') 
 	{
 		// alert("arc_1");
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var startangle = par4;
		var finishangle = unit;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		
 	}
 	else if (a=='arc_2') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var startangle = par4;
		var finishangle = unit;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,false);
		ctx.stroke();
		
 	}
 	else if (a=='arc_3') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5+radius;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();

		
 	}
 	else if(a=='rectangle')
 	{
 		var startx = par3*10;
 		var starty = par5*10;
 		var length = par1*10;
 		var breadth =par2*10;
 		var unit = unit;
 		var choice=par4;
 		if (choice==0) 
 		{
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		// ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		// ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else if (choice==1) 
  		{
  		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		// ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else if (choice==2)
  		{
  			ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		// ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else
  		{
  			ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
	}
	else if(a=='eqtriangle')
 	{
 		var choice = par4;
 		if (choice==0) 
 		{
 		var startx = par3;
 		var starty = par5;
 		var length = par1*10;
 		var unit = unit;
 		var height = (length/2)*Math.tan(Math.PI/3);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length,starty);
		ctx.lineTo(startx+length/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		sctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.textAlign="center";
  		ctx.fillText("Equilateral Triangle", 150,295);
  		}
  		else 
  		{
  		var startx = par3;
 		var starty = par5;
 		var length = par1*10;
 		var unit = unit;
 		var height = (length/2)*Math.tan(Math.PI/3);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length,starty);
		ctx.lineTo(startx+length/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
		ctx.beginPath();
		ctx.moveTo(startx+length/2,starty-height);
		ctx.lineTo(startx+length/2,starty);
		ctx.stroke();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText("height = "+(height/10).toFixed(2),startx+length/2,((starty)+(starty-height))/2);
  		ctx.textAlign="center";
  		ctx.fillText("Equilateral Triangle", 150,295);
  		}
	}
	else if(a=='isotriangle')
 	{	
 		var choice = par4;
 		if (choice==0) 
 		{
 		var startx = par3;
 		var starty = par5;
 		var length1 = par1*10;
 		var length2 = par2*10;
 		var unit = unit;
 		var angle = Math.acos(length2/(2*length1));
 		// alert("angle="+angle*180/Math.PI);
 		var height = (length2/2)*(Math.tan(angle));
 		// alert("height="+height);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length2,starty);
		ctx.lineTo(startx+length2/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		
  		ctx.fillText(" "+length2/10+""+unit, startx+length2/4, starty-5);
  		ctx.fillText(""+length1/10+""+unit,startx,starty-height/2);
  		ctx.textAlign="center";
  		ctx.fillText("Isoceles Triangle", 150,295);
  		}
  		else
  		{
  		// alert("white");
  		var startx = par3;
 		var starty = par5;
 		var length1 = par1*10;
 		var length2 = par2*10;
 		var unit = unit;
 		var angle = Math.acos(length2/(2*length1));
 		// alert("angle="+angle*180/Math.PI);
 		var height = (length2/2)*(Math.tan(angle));
 		// alert("height="+height);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length2,starty);
		ctx.lineTo(startx+length2/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		ctx.beginPath();
		ctx.moveTo(startx+length2/2,starty-height);
		ctx.lineTo(startx+length2/2,starty);
		ctx.stroke();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.fillText("height = "+(height/10).toFixed(2),startx+length2/2,((starty)+(starty-height))/2);
  		ctx.fillText(" "+length2/10+""+unit, startx+length2/4, starty-5);
  		ctx.fillText(""+length1/10+""+unit,startx,starty-height/2);
  		ctx.textAlign="center";
  		ctx.fillText("Isoceles Triangle", 150,295);
  		}
	}
	else if (a=='scalene') 
	{
		
		var choice = par4;
		var a = par1*10;
		var b = par2*10;
		var c = par3*10;
		if(((a+b)>c)&&((b+c)>a)&&((c+a)>b))
		{
			if (choice!=0)
			{
				// alert("black");
			var cosA = (b*b+c*c-a*a)/(2*b*c);
			var angleA = Math.acos(cosA);
			var sinA = Math.sin(angleA);
			var radius = a/(2*Math.sin(angleA));
			var cosB = (a*a+c*c-b*b)/(2*a*c);
			var angleB = Math.acos(cosB);
			var a1 = radius*sinA;
			var a2 = radius*cosA;
			var b1 = radius*Math.cos(0.5*Math.PI-(angleA+2*angleB));
			var b2 = radius*Math.sin(0.5*Math.PI-(angleA+2*angleB));
			var centrex = 150;
			var centrey =150;
			var height = Math.abs(b2-a2);
			ctx.beginPath();
			ctx.moveTo(centrex-a1,centrey+a2);
			ctx.lineTo(centrex+a1,centrey+a2);
			ctx.lineTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex-a1,centrey+a2)
			ctx.stroke();
			ctx.beginPath();
			ctx.moveTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex+b1,centrey+a2);
			ctx.stroke();
			ctx.fillStyle = "blue";
 			ctx.font = " 12px Arial";
			// ctx.fillText("height = "+height.toFixed(2),centrex+b1,((centrey+a2)+(centrey+b2))/2);
			ctx.fillText("height = "+(height/10).toFixed(2),130,282);

  			ctx.textAlign="center";
 			ctx.fillText(""+a/10+""+unit,centrex,centrey+a2+10);
 			ctx.fillText(""+b/10+""+unit,((centrex+a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
 			ctx.fillText(""+c/10+""+unit,((centrex-a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
  			ctx.fillText("Triangle", 150,295);
  			}
  			else
  			{
  			// alert("white");
  			var cosA = (b*b+c*c-a*a)/(2*b*c);
			var angleA = Math.acos(cosA);
			var sinA = Math.sin(angleA);
			var radius = a/(2*Math.sin(angleA));
			var cosB = (a*a+c*c-b*b)/(2*a*c);
			var angleB = Math.acos(cosB);
			var a1 = radius*sinA;
			var a2 = radius*cosA;
			var b1 = radius*Math.cos(0.5*Math.PI-(angleA+2*angleB));
			var b2 = radius*Math.sin(0.5*Math.PI-(angleA+2*angleB));
			var centrex = 150;
			var centrey =150;
			
			ctx.beginPath();
			ctx.moveTo(centrex-a1,centrey+a2);
			ctx.lineTo(centrex+a1,centrey+a2);
			ctx.lineTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex-a1,centrey+a2)
			ctx.stroke();
			ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  			ctx.textAlign="center";
  			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.fillText(""+a/10+""+unit,centrex,centrey+a2+10);
 			ctx.fillText(""+b/10+""+unit,((centrex+a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
 			ctx.fillText(""+c/10+""+unit,((centrex-a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
  			ctx.fillText("Triangle", 150,295);
  			}
		}
		else
		{
			alert("A triangle cannot be constructed with these side lengths.")
		}
	}
	else if (a=='regularpolygon') 
	{
		var choice = par4;
		var numsides=par1;
		var length = par2;
		var startx = 250;
 		var starty = 250;
 		var canvasy= par3;
 		var unit = unit;
		var side = length;
		var numsides = numsides;
		var angle = 180/numsides;
		var radius = side/(2*(Math.sin(angle)));
		if (choice==0)
		{
		for (var i = 0; i <numsides; i++) 
		{
			regularpoly_x[i]=(radius*Math.cos(2*Math.PI*i/numsides));
			regularpoly_y[i]=(radius*Math.sin(2*Math.PI*i/numsides));
			original2[3*i]=regularpoly_x[i];
			original2[3*i+1]= regularpoly_y[i];
			original2[3*i+2]=10;
		}
		createshape2(original2,unit,150,150,0);
		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.textAlign="center"; 
		// ctx.fillText("side length = "+length+""+unit,150, 280);
		ctx.fillText("Regular Polygon", 150,canvasy-5);
	}
	else
	{
		for (var i = 0; i <numsides; i++) 
		{
			regularpoly_x[i]=(radius*Math.cos(2*Math.PI*i/numsides));
			regularpoly_y[i]=(radius*Math.sin(2*Math.PI*i/numsides));
			original2[3*i]=regularpoly_x[i];
			original2[3*i+1]= regularpoly_y[i];
			original2[3*i+2]=10;
		}
		createshape2(original2,unit,250,250,0);
		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.textAlign="center"; 
		ctx.fillText("side length = "+length+""+unit,150,canvasy-20);
		ctx.fillText("Regular Polygon", 150,canvasy-5);
	}
		
	}
	else
	{
		alert("Shape not created.");
	}
}



function createshape2(arr,unit,par1,par2,par3)
{
	var choice = par3;
	var startx = par1;
 	var starty = par2;
 	var currx = startx+arr[0]*10;
 	var curry = starty+arr[1]*10;
 	var unit = unit;
 	if (choice==0)
 	{
 	ctx.beginPath();
	ctx.moveTo(currx,curry);
	// alert("initial  "+Math.floor(currx)+","+Math.floor(curry));
	for(var i =3;i<arr.length;i=i+3)
		{
			var lengthx = arr[i]*10;
			var lengthy = arr[i+1]*10;
			var length5 = arr[i-1];
			ctx.lineTo(startx+lengthx,starty+lengthy);
			// alert("new  "+Math.floor(startx+lengthx)+","+Math.floor(starty+lengthy));
			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
 			if (i!=0)
 			{ 
			// ctx.fillText(""+length5+""+unit, currx+((startx+lengthx)-(currx))/2, curry+((starty+lengthy)-(curry))/2);
			}
			else
			{
				// ctx.fillText(""+length5+""+unit, startx+(currx-startx)/2, curry+((starty+lengthy)-(curry))/2);
			}
			currx = startx+lengthx;
			curry = starty+lengthy;
		}
		var length5 = arr[arr.length-1];
		// ctx.fillText(""+length5+""+unit, (currx+startx+arr[0]*10)/2, (curry+starty+arr[1]*10)/2);
	ctx.closePath();
	ctx.strokeStyle = "black";
	ctx.stroke();
	}
	else
	{
		ctx.beginPath();
	ctx.moveTo(currx,curry);
	// alert("initial  "+Math.floor(currx)+","+Math.floor(curry));
	for(var i =3;i<arr.length;i=i+3)
		{
			var lengthx = arr[i]*10;
			var lengthy = arr[i+1]*10;
			var length5 = arr[i-1];
			// alert("length="+length5);
			ctx.lineTo(startx+lengthx,starty+lengthy);
			// alert("new  "+Math.floor(startx+lengthx)+","+Math.floor(starty+lengthy));
			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
 			if (i!=0)
 			{ 
			if (length5!=0)
				{
			ctx.fillText(""+length5+""+unit, currx+((startx+lengthx)-(currx))/2, curry+((starty+lengthy)-(curry))/2);
			}
			}
			else
			{
				if (length5!=0)
				{
				ctx.fillText(""+length5+""+unit, startx+(currx-startx)/2, curry+((starty+lengthy)-(curry))/2);
				}
			}
			currx = startx+lengthx;
			curry = starty+lengthy;
		}
		var length5 = arr[arr.length-1];
		if (length5!=0)
				{
		ctx.fillText(""+length5+""+unit, (currx+startx+arr[0]*10)/2, (curry+starty+arr[1]*10)/2);
	}
	ctx.closePath();
	ctx.strokeStyle = "black";
	ctx.stroke();	
	}

}

function createshape3(a,par1,par2,par3,par4,par5,unit,par6,par7,par8)
{
	if (a=='arc_3') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5+radius;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		var text1 = par6;
		var text2 = par7;
		var text3 = par8;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();
		ctx.fillStyle = "blue";
 		ctx.font = " 18px Tahoma";
  		ctx.fillText(""+text1+"", centrex, centrey+12);
  		ctx.fillText(""+text2+"", x1, y1-5);
  		ctx.fillText(""+text3+"", x2+5, y2+5);
 	}
 	else if (a=='arc_4')
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		var text1 = par6;
		var text2 = par7;
		var text3 = par8;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,false);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();
		ctx.fillStyle = "blue";
 		ctx.font = " 18px Tahoma";
  		ctx.fillText(""+text1+"", centrex, centrey+12);
  		ctx.fillText(""+text2+"", x1, y1-5);
  		ctx.fillText(""+text3+"", x2+5, y2+5);
 	}
}
