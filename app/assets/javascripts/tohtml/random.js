function input1(num,exp)
{	
	

	var maxexp = exp;
	var maxvariable = num;
	// alert("blah")
	var table=document.getElementById("table");
   var r = table.insertRow(0);
   for(var i=0;i<num;i++)
        {
        	var name = variablearray[i];
        	for(var j=0;j<exp;j++)
        	{
        
        		var cellname = name +name+ j;
        		var cell = r.insertCell(j);
           		var k = j+1;
           		cell.id = cellname;
          
		   		cell.style.width="100px";
		  		
		  		var buttonname = name+k;
		   		var btn=document.createElement("BUTTON");
		  
		    	var spanSuper = "<sup>"+k+"</sup>";    
		   		btn.setAttribute("type","button");
		   		btn.innerHTML = name+spanSuper;
		   		btn.id = buttonname;
		   		btn.class = "new";
 		   		btn.onclick = function(){myfunc(this.id);};
		   		var b=document.getElementById(cellname);
		   		// $("#"+cellname).appendChild(btn);
		   		b.appendChild(btn);
			}
        }
}

function myfunc(char,num,exp)
        {	

			var maxexp = exp;
			var maxvariable = num;
            
            var text = document.getElementById("textfield"); 
        	
            var val = text.innerHTML;
			var ch = char;
            switch(ch)
            {
                case "BackSpace":
                // alert("BackSpace");
                if(val.charAt(val.length-1) ==" ")
                {text.innerHTML = val.substr(0, val.length - 1);}
                else if(val.charAt(val.length-1) =="+")
                {	
                	text.innerHTML = val.substr(0, val.length - 1);
                	var val = text.innerHTML;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{sign=1;
                	// alert("sign is"+sign)
                	}
                	else{
                	sign=0;
                	// alert("sign is"+sign);
                	}
                	deleted =1;
                	// alert("deleted is "+deleted);
                	
                }
                else if(val.charAt(val.length-1) =="-")
                {
                	text.innerHTML = val.substr(0, val.length - 1);
                	var val = text.innerHTML;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{sign=1;
                	// alert("sign is"+sign)
                	}
                	else{
                	sign=0;
                	// alert("sign is"+sign);
                	}
                	deleted=1;
                	
                }
                else if(val.charAt(val.length-1) ==">")
                {
                  // alert("yes");
                var d=0;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{
                		d=1;
                		// alert("sign is"+sign)
                	}
                	else
                	{
                		d=0;
                		// alert("sign is"+sign);
                	}
                	var check = 0;
                	for(var i=0;i<6;i++)
					         {check +=arrayexp[i]; }
					
					
					
					         if(check==0)
                	 {
                		var len=0;
                		var a = n+1;
                		var b ="";
                		var c =val.charAt(a);
                		while((c==0)||(c==1)||(c==2)||(c==3)||(c==4)||(c==5)||(c==6)||(c==7)||(c==8)||(c==9))
  						        { 
  							         b=b+c;
  							         a++;
  							         c=val.charAt(a);
  							         len++;
  							         // alert("length of coeff is "+len); 
  						        }
  						      if(b=="")
                		  {b=1;}
                		// alert("coeef is"+b);
						        var c1 = parseInt(b);
						      // alert("coeef is"+c1);
                		if(d==0)
                		{}
                		else
                		{c1 = (-1)*(c1)};
                		// alert("coeef is"+c1);
  						var a1 = val.charAt(a,a);
  						// alert("variable is "+a1);
                		var b1 = val.charAt(a+6, a+6);
//                 		alert("expo is"+b1);
// 			alert("a is "+a);
// 			alert("length is" +val.length);
// 			a= a+13;
                		while(a<val.length)
                 		{
// 			                 alert("blah");
		                	var c2 = parseInt(b1);
// 		                	alert("c2 is "+c2)
        		        	// var spanSuper = "<sup>"+a+"</sup>";               
//                				text.innerHTML += b+spanSuper;  
               				for(var i=0;i<6;i++)
               				{
               					if(a1==variablearray[i])
               					{arrayexp[i] +=c2;
				               		// alert("Value of arrayexp outside the function " + arrayexp[i]);
               					};
               				}
               				a = a+13;
               				// alert("a is "+a);
               				var a1 = val.charAt(a,a);
//                				alert("variable is "+a1);
                			var b1 = val.charAt(a+6, a+6);
               			}	
               			var ind = getindex(6,maxexp);
               			// alert("index is "+ind);
               			// alert("array coefficient is"+	arraycoeff[ind]);
               			arraycoeff[ind]= arraycoeff[ind]-c1;
               			// alert("array coefficient is"+	arraycoeff[ind]);
                    chHTable(index);
               			for(var i=0;i<6;i++)
						{arrayexp[i] =0;}
               		}
               	 else
               		{
               			for(var i=0;i<6;i++)
						{arrayexp[i] =0;}
						coefficient ="";
               		}
                text.innerHTML = val.substr(0, n);
                }
               else
               {
//                alert("deleted is "+deleted);
               if(deleted==1)
               {
               	var d=0;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{
                		d=1;
//                  		alert("sign is"+sign)
                	}
                	else
                	{
                		d=0;
//                 		alert("sign is"+sign);
                	}
                	
                	var len=0;
                		var a = n+1;
                		var b ="";
                		// var c =val.charAt(a);
//                 		while((c==0)||(c==1)||(c==2)||(c==3)||(c==4)||(c==5)||(c==6)||(c==7)||(c==8)||(c==9))
//   						{
//   							b=b+c;
//   							a++;
//   							c=val.charAt(a);
//   							alert("character is"+c);
//   							len++;
//    							alert("length of coeff is "+len); 
//   						}
						var b = val.substr(a, val.length)
  						if(b=="")
                		{b=1;}
//                 		alert("coeef is"+b);
						var c1 = parseInt(b);
// 						alert("coeef is"+c1);
                		if(d==0)
                		{}
                		else
                		{c1 = (-1)*(c1)};
//                 		alert("constant is"+	arraycoeff[0]);
                		arraycoeff[0]= arraycoeff[0]-c1;
                    chHTable(index);
//                 		alert("constant is"+	arraycoeff[0]);
                		text.innerHTML = val.substr(0, a);
                		coefficient="";
                		
                	
               }
               else
               {
                text.innerHTML = val.substr(0, val.length - 1);
                coefficient=coefficient.substr(0,coefficient.length-1);
                // alert("coeff is"+coefficient);
                }
                }
                break;
	
                
                
                case "Enter":
                    // alert("Enter");
                   text.innerHTML += "<br>";
                   intcoefficient = parseInt(coefficient);
                   if(coefficient=="")
                    {intcoefficient =1;}
                	 
                   index = getindex(6,maxexp);
                   if(sign==0){}
	        		       else{intcoefficient = -1*intcoefficient;}
        		      // alert("Value of index outside the function " + index);
					       if(coefficient!="")
					       {
					       if(arraycoeff[index]===undefined)
	        		   {arraycoeff[index]= intcoefficient;}
	        		   else{arraycoeff[index]+= intcoefficient;}

	        		     // alert("Value at index  " + arraycoeff[index]);
	        	 // $("#table2"+" tr:eq("+index+")").find("input:eq("+index+")").attr("value", arraycoeff[index]); 
               // $(document).ready(function(){
               // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
               //  });
              // $("#"+table2+" tr:eq("+index+")").innerHTML(arraycoeff[index]); 
                   
                   chHTable(index);
                   for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
                   }
                   coefficient = "";
                    break;

	        	case "+ ":
	        		 // alert("+");
	        		text.innerHTML += ch;
	        		intcoefficient = parseInt(coefficient);
	        		if(coefficient=="")
	        		{intcoefficient =1;}
	        		index=getindex(6,maxexp);
	        		if(sign==0){}
	        		else{intcoefficient = -1*intcoefficient;}
        		// alert("Value of index outside the function " + index);
					
					if(arraycoeff[index]===undefined)
	        		{arraycoeff[index]= intcoefficient;}
	        		else{arraycoeff[index]+= intcoefficient;}
  	        		// alert("Value at index  " + arraycoeff[index]);
 	        		 chHTable(index);
 	        		for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
					
					
					sign=0;
					coefficient = "";
	        	break; 
	        	
	        	case "- ":
	        		// alert("-");
	        		text.innerHTML += ch;
	        		intcoefficient = parseInt(coefficient);
	        		if(coefficient=="")
	        		{intcoefficient =1;}
	        		index=getindex(6,maxexp);
	        		if(sign==0){}
	        		else{intcoefficient = -1*intcoefficient;}
        		// alert("Value of index outside the function " + index);
	        		
	        		if(arraycoeff[index]===undefined)
	        		{arraycoeff[index]= intcoefficient;}
	        		else{arraycoeff[index]+= intcoefficient;}
	        		// alert("Value at index  " + arraycoeff[index]);
	        		chHTable(index);
	        		for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
					
					
					sign=1;
					coefficient = "";
	        	break;   
               
               default:
               	if(ch.length==1)
                  { text.innerHTML += ch;
                  	coefficient +=ch;
                  	// alert(coefficient);
                  }
                else
                { 
                var a = ch.substr(ch.length-1,ch.length);
                var b = ch.substr(ch.length-2, ch.length - 1);
//                 if(coefficient==0){coefficient=1;};
//                 alert("blah"+a);
                var c = parseInt(a);
                var spanSuper = "<sup>"+a+"</sup>";               
               	text.innerHTML += b+spanSuper;  
               	for(var i=0;i<6;i++)
               	{
               		if(b==variablearray[i])
               		{arrayexp[i] +=c;
               		// alert("Value of arrayexp outside the function " + arrayexp[i]);
               		// alert("variable is "+variablearray[i])
               		};
               	}
                	
                }
                   
            }
        }

function getindex(num,exp)
{	var a= 0;

	var maxexp = exp;
	
	for(var i=0;i<num;i++)
	{
		a+= arrayexp[i]*(Math.pow(maxexp,i));
		// alert("calculating index..location"+i+"value=="+arrayexp[i]);
	}
	// alert("index is "+a);
	return a;
}

  function chHTable(index){
                
                      var index=index;
                      $("#table2"+" tr:eq("+index+")").find("input:eq("+index+")").attr("value", arraycoeff[index]); 
                      // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
                   
                 
               } 









