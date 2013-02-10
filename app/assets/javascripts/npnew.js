
function notepad_new() {
	// global drawing variables
	var canvas = $('#notepad')[0];
	var context = canvas.getContext('2d');
	$("#npcolorpicker").val("#000000");
	var notes=[];
	var mousex;
	var downx;
	var mousey;
	var downy;
	var draw=[];
	var mousedown=false;
	var lheight=20;
	var mode="wr";
	var pane=$("#note").jScrollPane().data("jsp");
	function addline(ln, lsp){
		lsp = typeof lsp !== 'undefined' ? lsp : 0;
		$("#npPane").append("<p style=\"position:absolute; text-indent:"+lsp*8+"px; left:2px; top:"+(2+notes.length*lheight)+"px; width:"+canvas.width+"px\">"+ln+"</p>");
		notes.push(ln);
		$('#notes').attr("value", "");
		$('#notes').css("top", ""+(notes.length*lheight+13)+"px");
		canvas.height=Math.max(parseInt($("#notes").css("top"))+15, canvas.height);
		context.lineWidth=3;
		for(j=0; j<draw.length; j++){
			if(draw[j].length>1){
				context.strokeStyle=draw[j][0][2];
				context.lineWidth=2;
				for(k=1; k<draw[j].length; k++){
					drawLine(draw[j][k-1][0], draw[j][k-1][1], draw[j][k][0], draw[j][k][1]);
				}
			}
			context.lineWidth=1;
		}
		pane.reinitialise();
		pane.scrollToPercentY(100, true);
	}
	$("#drawnp").click(function(e){
			if(mode!="dr"){
			mode="dr";
			$("#npPane").hide();
			$("#notes").hide();
			for(i=0; i<notes.length; i++){
			context.fillStyle="rgb(85, 102, 119)"; 
			context.font="10pt Courier";
			context.fillText(notes[i], 2, i*lheight+12); 
			}
			}
			else{
			mode="wr";
			$("#npPane").show();
			$("#notes").show();
			$("#notes").focus();
			}
			});
	$("#notepad").mousedown(function(e){
			mousedown=true;
			if(mode=="wr"){
			pane.scrollToPercentY(100, true);
			$("#notes").focus();
			}
			if(mode=="dr"){
			context.lineWidth=3;
			context.strokeStyle=$("#npcolorpicker").val();
			downx = mousex;
			downy = mousey;
			draw.push([])
			draw[draw.length-1].push([downx, downy, $("#npcolorpicker").val()]);
			}
			});
	$("#notepad").mouseup(function(e){
			context.lineWidth=1;
			mousedown=false;
			});
	$('#notepad').mousemove(function (e) { 
			// mousex and mousey are used for many things, and therefore need to be in the
			// global scope.
			var offset = $('#notepad').offset();
			var offsetx = Math.round(offset.left);
			var offsety = Math.round(offset.top);

			mousex = e.pageX - offsetx; // - offset.left;
			mousey = e.pageY - offsety; // - offset.top;
			if(mousedown && mode=="dr"){
			drawLine(draw[draw.length-1][draw[draw.length-1].length-1][0], draw[draw.length-1][draw[draw.length-1].length-1][1], mousex, mousey);
			draw[draw.length-1].push([mousex, mousey]);
			}
			});
	$('#notes').keypress(function(e){
			pane.scrollToPercentY(100);
			if(e.keyCode==13) {
			addline($('#notes').attr("value"));
			}
			});
	function drawLine(x1,y1, x2, y2) {
		context.beginPath();
		context.moveTo(x1,y1);
		context.lineTo(x2, y2);
		context.stroke();
		context.closePath();
	}
	adding=true;
	$("#np_add").css("background-color","gray");
	subtracting=false;
	multiplying=false;
	$("#np_add").click(function(e){
			if(!adding){
			adding=true;
			multiplying=false;
			subtracting=false;
			$(".tbicons").css("background-color", "white");
			$(this).css("background-color", "gray");
			}
			});
	$("#np_sub").click(function(e){
			if(!subtracting){
			adding=false;
			multiplying=false;
			subtracting=true;
			$(".tbicons").css("background-color", "white");
			$(this).css("background-color", "gray");
			}
			});
	$("#np_mult").click(function(e){
			if(!multiplying){
			adding=false;
			multiplying=true;
			subtracting=false;
			$(".tbicons").css("background-color", "white");
			$(this).css("background-color", "gray");
			}
			});
	$("#cr_opform").click(function(e){
			createform_np();
			});
	function createform_np(){
		$("#calc").hide();
		if(adding){
			adding_np($("#np_num1").attr("value"), $("#np_num2").attr("value"), "+");
		}
		if(subtracting){
			adding_np($("#np_num1").attr("value"), $("#np_num2").attr("value"), "-");
		}
		if(multiplying){
			mult_np($("#np_num1").attr("value"), $("#np_num2").attr("value"));
		}

	}
	function adding_np(n1, n2, sign){
		lt=1+Math.max(n1.length, n2.length);
		var ht="<table id=laddtable border=0>\n";
		ht+="<tr>\n";
		for(i=0; i<lt-n1.length; i++){
			ht+="<td> </td>\n";
		}
		for(i=0; i<n1.length; i++){
			ht+="<td>"+n1[i]+"</td>\n";
		}
		ht+="</tr>\n";
		ht+="<tr>\n";
		for(i=0; i<lt-n2.length; i++){
			if(i==0){	
				ht+="<td>"+sign+"</td>\n";
			}
			else {ht+="<td> </td>\n";}
		}
		for(i=0; i<n2.length; i++){
			ht+="<td>"+n2[i]+"</td>\n";
		}
		ht+="</tr>\n";
		ht+="<tr>\n";
		for(i=0; i<lt; i++){
			ht+="<td><input type=text class=linps id=lin"+i+" maxlength=1 style=\"width:15px; height:10px\"></td>\n";
		}
		ht+="</tr>\n";
		ht+="</table>";
		$('#ops_form').append(ht);
		$('#laddtable').attr("style", "background-color:transparent; font:10pt Courier;");
		$("#lin"+(lt-1)).select();
		$(".linps").keypress(function(e){
				String.fromCharCode(e.keyCode)
				if(e.keyCode > 47 && e.keyCode < 58) {
				$(this).attr("value", String.fromCharCode(e.keyCode));
				}
				var tot="";
				if (e.keyCode==13){
				for(var i=0; i<lt; i++){
				tot+=$("#lin"+i).attr("value");
				}
				addline(n1+" "+sign+" "+n2+" = "+tot);
				context.strokeStyle="black";
				$('#laddtable').remove();
				$('#calc').show();

				}
		});
		for (var j=1; j<lt; j++)
		{
			$("#lin"+j).keypress({j:j}, function(e){
					$("#lin"+(e.data.j-1)).select();
					});
		}
	}
	function mult_np(n1, n2){
		lt=1+n1.length+n2.length;
		var ht="<table id=addtable border=0>\n";
		ht+="<tr>\n";
		for(i=0; i<lt-n1.length; i++){
			ht+="<td> </td>\n";
		}
		for(i=0; i<n1.length; i++){
			ht+="<td>"+n1[i]+"</td>\n";
		}
		ht+="</tr>\n";
		ht+="<tr>\n";
		for(i=0; i<lt-n2.length; i++){
			if(i==0){	
				ht+="<td>x</td>\n";
			}
			else {ht+="<td> </td>\n";}
		}
		for(i=0; i<n2.length; i++){
			ht+="<td>"+n2[i]+"</td>\n";
		}
		ht+="</tr>\n";
		for (j=0; j<n2.length; j++){
			ht+="<tr>\n";
			for(i=0; i<lt-(n1.length+j+1); i++){
				if(i==0 && j!=0){	
					ht+="<td>+</td>\n";
				}
				else {ht+="<td> </td>\n";}
			}
			for(i=0; i<(n1.length+j+1); i++){
				ht+="<td><input type=text class=inps"+j+" id=in_"+j+"_"+i+" maxlength=1 style=\"width:15px; height:10px\"></td>\n";
			}
			ht+="</tr>\n";
		}
		if(n2.length>1){
			for(i=0; i<lt; i++){
				ht+="<td><input type=text class=inps id=in"+i+" maxlength=1 style=\"width:15px; height:10px\"></td>\n";
			}
		}
		ht+="</tr>\n";
		ht+="</table>";
		//alert(ht);
		$('#ops_form').append(ht);
		$('#addtable').attr("style", "background-color:transparent; font:10pt Courier;");
		$("#in_0_"+(n1.length)).select();
		for(j=0; j<n2.length; j++){
			if(j==n2.length-1){
				$(".inps"+j).keypress(function(e){
						if (e.keyCode==13){
						$("#in"+(lt-1)).select();
						}
						});
			}
			else{
				$(".inps"+j).keypress({j:j}, function(e){
						if (e.keyCode==13){

						$("#in_"+(e.data.j+1)+"_"+(n1.length)).select();
						for(i=0; i<j; i++){
						$("#in_"+(e.data.j+1)+"_"+(n1.length+1+i)).attr("value","0");
						}
						}
						});
			}
		}
		if(n2.length==1){
			$(".inps0").keypress(function(e){
					var tot="";
					if (e.keyCode==13){
					for(var i=0; i<lt-1; i++){
					tot+=$("#in_0_"+i).attr("value");
					}
					addline(n1+" x "+n2+" = "+tot);
					$('#addtable').remove();
					$('#calc').show();
					$('#notes').focus();
					}

			});
		}
		else {
			$(".inps").keypress(function(e){
					var tot="";
					if (e.keyCode==13){
					for(var i=0; i<lt; i++){
					tot+=$("#in"+i).attr("value");
					}
					addline(n1+" x "+n2+" = "+tot);
					$('#addtable').remove();
					$('#calc').show();
					$('#notes').focus();
					}
			});
		}
		for (var j=1; j<lt; j++){
			$("#in"+j).keypress({j:j}, function(e){
					if (e.keyCode!=13){
					e.preventDefault();
					$("#in"+(e.data.j)).attr("value", String.fromCharCode(e.keyCode));
					$("#in"+(e.data.j-1)).select();
					}
					});
		}
		for(var j=0; j<n2.length; j++){
			for(var i=1; i<n1.length+j+1; i++){
				$("#in_"+j+"_"+i).keypress({j:j, i:i}, function(e){
						if (e.keyCode!=13){
						e.preventDefault();
						$("#in_"+(e.data.j)+"_"+(e.data.i)).attr("value", String.fromCharCode(e.keyCode));
						$("#in_"+(e.data.j)+"_"+(e.data.i-1)).select();
						}
						});
			}
		}

	}
}
