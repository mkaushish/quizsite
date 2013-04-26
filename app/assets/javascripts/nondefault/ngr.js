
var canvas = $('#canvas')[0];
var curve = $('#curves')
var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var mousedown=false;
  cur_fn=0;
  fnarr=[];
function fnc (exp, clr){
	cur_fn+=1;
	this.exp=exp;
	this.parsed=parseFN(this.exp);
	if(clr==null){
		this.color=freeColor();
	}
	else {this.color=clr;}
	this.lwidth=1;
	this.thick=false;
	this.update=function(){
		this.pos=fnarr.index(this);
		this.side_html=fn_side_html(this.pos);
		fn_callbacks(this.pos);
	}
	this.update();
	this.evaluate=function(){
		evaluate(this.pos);
	}
	this.evaluate_at_x=function(xval){
		return evaluatefn(this.parsed, xval);
	}
    this.draw=function(){
      context.lineWidth=this.lwidth;
      this.ret=drawfunction(this.fn);
      context.lineWidth=1;
      this.values=this.ret[0];
      this.pos=this.ret[1];
      return this.values;
    }
}

fn_side_html=function(w){
	h="<div class=shape style=\"background-color:"+fnarr[w].color+";\" id=s_"+w+" >\ny="+fnarr[w].exp;  
	h+="\n<i class=\"icon-remove-sign icon-white deleteb\" id=delete_"+w+"></i>\n";
	h+="</div>\n";
	return h;
}

evaluatefn=function(sy, xval){
    form=new Array();
    for(i=0; i<sy.length; i++){
      if (!isNaN(sy[i])){
        form.push(sy[i]);
      }
      else if(sy[i]=="x"){
        form.push(xval);
      }
      else if(fns.indexOf(sy[i])!=-1){
        form.push(operation(sy[i], form.pop(), 0));
      }
      else { 
        form.push(operation(sy[i], form.pop(), form.pop())); }
    }
    return form[0];
}

evaluate=function(w){
	sy=fnarr[w];
	var values=new Array();
	var pos=new Array();
	var ke;  
	var ve;
	for(q=off; q<canvas.width-off; q+=1){
		xpos=q;
		curx=czoom*(xpos-cx)/width;
		cury=evaluatefn(sy,curx)/czoom;
		ypos=(cy-width*cury);
		if (ypos>=0 && ypos<=canvas.height+off){
			values.push([curx,cury]);
			pos.push([q,Math.round(ypos)]);
			if(q>off) {
				if(Math.abs(distance(ve[0],ve[1],curx, cury)) < 2*czoom){
					drawLine(ke[0],ke[1],xpos,ypos);
				}
				else {context.fillRect(xpos,ypos, 1, 1);} 
			}
		}
		ke=[xpos, ypos];
		ve=[curx, cury];
	} 
	return [values, pos];
}

fn_callbacks=function(w){
	$('#s_'+(w)).mouseenter({w:w}, function(e) {
		fnarr[e.data.w].lwidth=3;
		redraw();
	});
	$('#s_'+(w)).click({w:w}, function(e) {
		if(!fnarr[e.data.w].thick){
			fnarr[e.data.w].lwidth=3;
			fnarr[e.data.w].thick=true;
			redraw();
		}
		else {
			fnarr[e.data.w].lwidth=1;
			redraw();
			fnarr[e.data.w].thick=false;
		}
	});
	$('#s_'+(w)).mouseleave({w:w}, function(e) {
		fnarr[e.data.w].lwidth=1;
		redraw();
	});
	$('#delete_'+(w)).click({w:w}, function(e) {
		deleteCurve(e.data.w);
	});
}

function operation(op, lt, rt) {
	if (op=="+") {
		return lt+rt;}
		if (op=="-") {return rt-lt;} 
		if (op=="*") {return lt*rt;}
		if (op=="/") {return rt/lt;}
		if (op=="^") {return Math.pow(rt,lt);}
		if (op=="q") {return Math.asin(lt);}
		if (op=="r") {return Math.acos(lt);}
		if (op=="k") {return Math.atan(lt);}
		if (op=="s")
		{
			return Math.sin(lt);
		}
		if (op=="c")
		{
			return Math.cos(lt);
		}
		if (op=="t")
		{
			return Math.tan(lt);
		}
		if (op=="u")
		{
			return 1/Math.tan(lt);
		}
		if (op=="d")
		{
			return 1/Math.cos(lt);
		}
		if (op=="o")
		{
			return 1/Math.sin(lt);
		}
		if (op=="l")
		{
			return Math.log(lt);
		}
	}

	sop=new Object();
	sop["sin"] = "s";
	sop["cos"] = "c";
	sop["tan"] = "t"; 
	sop["pi"] = "p";
	sop["cosec"] = "o";
	sop["sec"] = "d";
	sop["cot"] = "u";
	sop["log"] = "l";
	sop["asin"]= "q";
	sop["acos"]= "r";
	sop["atan"]= "k";
	fns=["q","r","k","s","c","t","o","d","u","l"];
	opers=new Object();
	opers["^"]=1;
	opers["/"]=2;
	opers["*"]=2;
	opers["+"]=3;
	opers["-"]=3;
	ops=["asin", "acos", "atan", "sin", "cosec", "cos", "sec", "tan", "cot", "pi", "log"];
	lbrac=["(","{","[","|"];
		rbrac=[")","}","]","|"];
function isOperator(op){
	if (opers[op]!=null){
		return true;
	}
	else {return false;}
}

function parseFN(fn) {
	for (i=0; i<fn.length; i++)
	{
		if (fn.charAt(i)==" ")
		{
			fn=fn.substr(0,i)+fn.substr(i,fn.length);
		}
	}
	for (i=0; i<ops.length; i++)
	{
		while (fn.indexOf(ops[i])!=-1)
		{
			fn=fn.substr(0, fn.indexOf(ops[i]))+sop[ops[i]]+fn.substr(fn.indexOf(ops[i])+ops[i].length, fn.length);
		}
	}
	tokens=new Array();
	if (fn[0]=="-") {fn="0"+fn;}
	for (i=0; i<ops.length; i++){
		if (fn[i]=="-" && fn[i-1]=="("){
			fn=fn.substr(0,i)+"0"+fn.substr(i,fn.length);
		}
	}

	var out=new queue();
	var op=new Array();
	for (i=0; i< fn.length; i+=1){
		var temp=fn.charAt(i);
		tokens.push(fn.charAt(i));
		if (fn.charAt(i)=="x"){
			if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="p" || tokens[tokens.length-2]=="e" || tokens[tokens.length-2]=="x") {op.push("*"); }
			out.enqueue("x");
		}
		else if (fn.charAt(i)=="p") {
			out.enqueue(Math.PI);
			if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="x" || tokens[tokens.length-2]=="e") 
				{op.push("*");}
		}

		else if (fn.charAt(i)=="e") {
			if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="x" || tokens[tokens.length-2]=="p") {op.push("*");
			out.enqueue(Math.E);
		}
	}
	else if (!isNaN(temp))
	{
		var nm=+temp;
		var j=2;
		temp=fn.substr(i,j);
		while (!isNaN(temp) && j+i<=fn.length){
			nm=+temp;
			j+=1;
			temp=fn.substr(i,j);
		}
		i=i+j-2;
		out.enqueue(nm);
	}
	else if (fns.indexOf(fn.charAt(i))!=-1)
	{
		if(lbrac.indexOf(fn.charAt(i+1))==-1){
			alert("Error: There has to be a bracket after trignometric, log functions");
			return false;
		}
		op.push(fn.charAt(i));
	}
	else if (isOperator(fn.charAt(i)))
	{
		while (op.length!=0 && isOperator(op[op.length-1])){
			if(["+","-","*","/"].indexOf(fn.charAt(i))!=-1){
				if(opers[fn.charAt(i)] >= opers[op[op.length-1]]){
					out.enqueue(op.pop());
				}
				else break;
			}
			if(fn.charAt(i)=="^"){
				if(opers[fn.charAt(i)] > opers[op[op.length-1]]){
					out.enqueue(op.pop());
				}
				else break;
			}
		}
		op.push(fn.charAt(i));
	}
	else if (lbrac.indexOf(fn.charAt(i))!=-1)
	{
		if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="x" || tokens[tokens.length-2]=="p" || tokens[tokens.length-2]=="e" || rbrac.indexOf(tokens[tokens.length-2])!=-1) {op.push("*");}
		op.push(fn.charAt(i));
	}
	else if (rbrac.indexOf(fn.charAt(i))!=-1)
	{
		while (op[op.length-1]!=lbrac[rbrac.indexOf(fn.charAt(i))])
		{
			if (op.length==0)
			{
				alert("Error: mismatched parentheses");
				return false;
			}
			out.enqueue(op.pop());
		}
		op.pop();
		if (fns.indexOf(op[op.length-1])!=-1) {out.enqueue(op.pop());}
	}
	else {
		alert("Error: symbol not recognized");
		return false; 
	}

}

while (op.length!=0)
{
	if (op[op.length-1]=="(")
	{
		alert("Error: mismatched parentheses");
		return false;
	}
	t=op.pop();
	out.enqueue(t);

}

var tr=out.arr();
return tr;
}


COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
ccolor=new Array();
for (var a=0; a<COLOR.length; a++){
	ccolor[a]=false;
}

function freeColor(){
	var cl="";
	for( var a=0; a<ccolor.length; a++){
		if(!ccolor[a]) {
			cl=COLOR[a];
			ccolor[a]=true;
			break;
		}
	}
	if(cl==""){
		COLOR.push(get_random_color());
		cl=COLOR[COLOR.length-1];
		ccolor[a]=true;
	}
	return cl;
}
