 
      $(function() {
        // global drawing variables
        var canvas = $('#canvas')[0];
        var context = canvas.getContext('2d');
        var mousex;         // global mouse position x coord
        var mousey;         // global mouse position y coord
        var downx;          // x coord where the click started
        var downy;          // y coord where the click started
        var mousedown=false;
        var off=25;         // offset from edges
        var state;
        var zoompos = 180;
        var minnegx=null;
        var maxnegx=null;
        var minposx=null;
        var maxposx=null;
        var minnegy=null;
        var maxnegy=null;
        var minposy=null;
        var maxposy=null;
        var maxx=null;
        var maxy=null;
        var minx=null;
        var miny=null;
        var cx=canvas.width/2;
        var cy=canvas.height/2;
        var width=0;
        var czoom=1;
        var fnarr=new Array();
        var graph={  
          num : 10,
          centerx : (canvas.width)/2, 
          centery : (canvas.height)/2,
          snum : 10,
          mid : 0,
          diff : 1,
          zbarc : zoompos,
          initz : zoompos,
          zoomin : [1, 0.5, 0.25, 0.2, 0.1, 0.05],
          zoomout : [1, 2, 5, 10, 50, 100],
          zoominf : [1, 2, 4, 5, 10, 20],
          iewid : Math.floor((canvas.width-2*off)/100), 
          ewid : Math.floor((canvas.width-2*off)/100),
          lower : 40,
          upper : 320,
          ldiv : 20,
          fdiff : 1,
          movemid : function() {
            var mmovx=mousex-downx;
            var mmovy=mousey-downy;
            downx=mousex;
            downy=mousey;
            this.centerx+=mmovx;
            this.centery+=mmovy;
          },
          zoom : function(dist) {
            this.ewid=Math.max(this.iewid*(dist/this.ldiv), 2.5);
            width=this.ewid*this.snum;
          },
          moveZBar : function() {
            var mmov=mousey-downy;
            downy=mousey;
            if (mmov+this.zbarc <= this.upper-this.ldiv-1 && mmov+this.zbarc >= this.lower+this.ldiv+1) {
              this.zbarc+=mmov;
              zoompos=this.zbarc;
              if (this.zbarc < this.initz) {
                this.diff=this.zoomout[Math.floor((this.initz-this.zbarc)/this.ldiv)];
                czoom=this.diff;
                this.zoom(this.ldiv -(this.initz-this.zbarc)+Math.floor((this.initz-this.zbarc)/this.ldiv)*this.ldiv);
              }
              else {
                this.diff=this.zoomin[Math.floor((this.zbarc-this.initz)/this.ldiv)];
                czoom=this.diff;
                this.fdiff=this.zoominf[Math.floor((this.zbarc-this.initz)/this.ldiv)];
                this.zoom((this.zbarc-this.initz)-Math.floor((this.zbarc-this.initz)/this.ldiv)*this.ldiv);
              }
            }
          },
          curpos : function() {
            m=this.ewid*this.snum
            //writeMessage("minx= "+minx+", maxx= "+maxx+", miny= "+miny+", maxy= "+maxy);
            writeMessage("x=" + Math.round((this.diff*(mousex-this.centerx)/m)*100)/100 +", y="+ Math.round((this.diff*(this.centery-mousey)/m)*100)/100);
          },
          drawZBar : function() {
            context.strokeStyle = "black";
            drawLine(5,this.lower,5,this.upper);
            drawLine(5,this.upper,15,this.upper);
            drawLine(15,this.upper,15,this.lower);
            drawLine(15,this.lower,5,this.lower);
            drawLine(5,this.zbarc-this.ldiv,5,this.zbarc+this.ldiv);
            drawLine(5,this.zbarc+this.ldiv,15,this.zbarc+this.ldiv);
            drawLine(15,this.zbarc+this.ldiv,15,this.zbarc-this.ldiv);
            drawLine(15,this.zbarc-this.ldiv,5,this.zbarc-this.ldiv);
          },
          draw : function(type) {
            context.strokeStyle = "b9b9b9";
            var first=canvas.width-off;
            var last=off;
            t=this.mid;
            var ct=this.mid;
            var cou=0;
            for (i=this.centerx; i >= off; i-=this.ewid*this.snum){
              if (i <= canvas.width-off) { 
                if (cou==0) {maxnegx=t;}
                cou+=1;
                drawLine(i, off, i, canvas.height-off);
                if (i !=this.centerx) {
                  if (type == "dec" || this.diff >= 1){
                    context.font = "9pt Calibri";
                    context.fillStyle = "black";
                    if ((Math.round(t*1000)/1000).toString().length < 2) {
                      context.fillText(Math.round(t*1000)/1000, i-5, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 3) {
                      context.fillText(Math.round(t*1000)/1000, i-10, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 4) {
                      context.fillText(Math.round(t*1000)/1000, i-15, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 5) {
                      context.fillText(Math.round(t*1000)/1000, i-20, this.centery+10);
                    }
                    else{
                      context.fillText(Math.round(t*1000)/1000, i-25, this.centery+10);
                    }
                  }
                  else {
                    var num=-ct;
                    var den=this.fdiff;
                    var hcf=gcd(num, den);
                    num=Math.round(num/hcf);
                    den=Math.round(den/hcf);
                    context.font = "9pt Calibri";
                    context.fillStyle = "black"; 
                    if(den !=1){
                      context.fillText(-num, i-9, this.centery+5);
                      context.fillText("__", i-9, this.centery+5);
                      context.fillText(den, i-9, this.centery+10)
                    }
                    else { context.fillText(-num, i-9, this.centery+5); }
                  }
                } 
              }
              minnegx=t;
              t-=this.diff;
              ct-=1;
            }
            context.fillText(0, this.centerx-5, this.centery+10);
            ct=this.mid;
            t=this.mid;
            cou=0;
            for (i=this.centerx; i <=canvas.width-off; i+=this.ewid*this.snum){
              if (i >= off){

                if (cou==0) {minposx=t;}
                cou+=1;
                drawLine(i, off, i, canvas.height-off);
                if(i!=this.centerx){
                  if (type == "dec" || this.diff >= 1){
                    context.font = "9pt Calibri";
                    context.fillStyle = "black" ;
                    if ((Math.round(t*1000)/1000).toString().length < 2) {
                      context.fillText(Math.round(t*1000)/1000, i-5, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 3) {
                      context.fillText(Math.round(t*1000)/1000, i-10, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 4) {
                      context.fillText(Math.round(t*1000)/1000, i-15, this.centery+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 5) {
                      context.fillText(Math.round(t*1000)/1000, i-20, this.centery+10);
                    }
                    else{
                      context.fillText(Math.round(t*1000)/1000, i-25, this.centery+10);
                    }
                  }
                  else {
                    var num=ct;
                    var den=this.fdiff;
                    var hcf=gcd(num, den);
                    num=Math.round(num/hcf);
                    den=Math.round(den/hcf);
                    context.font = "9pt Calibri";
                    context.fillStyle = "black";
                    if(den !=1){
                      context.fillText(num, i-9, this.centery+5);
                      context.fillText("__", i-9, this.centery+5);
                      context.fillText(den, i-9, this.centery+5);
                    }
                    else { context.fillText(-num, i-9, this.centery+5); }
                  }
                }
                maxposx=t;
                t+=this.diff;
                ct+=1;
              }
            }

            //y axis

            t=this.mid;
            var ct=0;
            cou=0;
            for (i=this.centery; i >= off; i-=this.ewid*this.snum){
              if (i <= canvas.width-off) {
                if (cou==0) {minposy=t;}
                cou+=1;
                drawLine(off, i, canvas.width-off, i);
                if (i !=this.centery) {
                  if (type == "dec" || this.diff >= 1){
                    context.font = "9pt Calibri";
                    context.fillStyle = "black";
                    if ((Math.round(t*1000)/1000).toString().length < 2) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-5, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 3) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-10, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 4) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-15, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 5) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-20, i+10);
                    }
                    else{
                      context.fillText(Math.round(t*1000)/1000, this.centerx-25, i+10);
                    }
                  }
                  else {
                    var num=-ct;
                    var den=this.fdiff;
                    var hcf=gcd(num, den);
                    num=Math.round(num/hcf);
                    den=Math.round(den/hcf);
                    context.font = "9pt Calibri";
                    context.fillStyle = "black";
                    if(den !=1){
                      context.fillText(-num, this.centerx-10, i-3);
                      context.fillText("__", this.centerx-10, i-3);
                      context.fillText(den, this.centerx-10, i+2)
                    }
                    else { context.fillText(-num, this.centerx-10, i); }
                  }
                } 
              }
              maxposy=t;
              t+=this.diff;
              ct+=1;
            }
            ct=0;
            t=this.mid;
            cou=0;
            for (i=this.centery; i <=canvas.width-off; i+=this.ewid*this.snum){
              if (i >= off){

                if (cou==0) {maxnegy=t;}
                cou+=1;
                drawLine(off, i, canvas.width-off, i);
                if(i!=this.centerx){
                  if (type == "dec" || this.diff >= 1){
                    context.font = "9pt Calibri";
                    context.fillStyle = "black";
                    if ((Math.round(t*1000)/1000).toString().length < 2) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-5, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 3) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-10, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 4) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-15, i+10);
                    }
                    else if ((Math.round(t*1000)/1000).toString().length < 5) {
                      context.fillText(Math.round(t*1000)/1000, this.centerx-20, i+10);
                    }
                    else{
                      context.fillText(Math.round(t*1000)/1000, this.centerx-25, i+10);
                    }
                  }
                  else {
                    var num=ct;
                    var den=this.fdiff;
                    var hcf=gcd(num, den);
                    num=Math.round(num/hcf);
                    den=Math.round(den/hcf);
                    context.font = "9pt Calibri";
                    context.fillStyle = "black"

                    if(den !=1){
                      context.fillText(num, this.centerx-10, i-3);
                      context.fillText("__", this.centerx-10, i-3);
                      context.fillText(den, this.centerx-10, i+2);
                    }
                    else { context.fillText(-num, this.centerx-10, i); }
                  }
                }
                minnegy=t;
                t-=this.diff;
                ct-=1;
              }
            }
            if (minnegx!=null) {
              minx=minnegx;
            }
            else {minx=minposx;}
            if(maxposx!=null) {
              maxx=maxposx;
            }
            else {maxx=maxnegx;}
            if(minnegy!=null) {
              miny=minnegy;
            }
            else {miny=minposy;}
            if(maxposy!=null) {
              maxy=maxposy;
            }
            else {maxy=maxnegy;}
            cx=this.centerx;
            cy=this.centery;
            width=this.ewid*this.snum;
          }
        }
        graph.draw("dec");
        graph.drawZBar();
        $('#canvas').mousedown(function (e) { 
          // downx and y have many uses
          downx = mousex;
          downy = mousey;
          mousedown=true;
        });

        $('#undo').click(function(){ 
          fnarr.pop();
          redraw();
        });
        $('#function').click(function(){ 
          var colour=["blue", "green", "yellow", "red"][fnarr.length % 4];
          context.strokeStyle=colour;
          fnarr.push(new fn($('#circlesize').attr("value"), colour));
          context.strokeStyle="black";
        });
        $('#canvas').mouseup(function (e) { 
          mousedown=false;
        });
        $('#canvas').scroll(function (e) { 

        });
        $('#canvas').mousemove(function (e) { 
          // mousex and mousey are used for many things, and therefore need to be in the
          // global scope.
          var offset = $('#canvas').offset();
          var offsetx = Math.round(offset.left);
          var offsety = Math.round(offset.top);
      
          mousex = e.pageX - offsetx; // - offset.left;
          mousey = e.pageY - offsety; // - offset.top;

          if(mousedown){
            if (downx > off){
              graph.movemid();
              context.clearRect(0,0,canvas.width, canvas.height);
              graph.draw("dec");
              graph.drawZBar();
            }
            if (downx > 5 && downx < 20 && downy > zoompos-25 && downy < zoompos+25){
              graph.moveZBar();
              context.clearRect(0, 0, canvas.width, canvas.height);
              graph.drawZBar();
              graph.draw("dec");
            }
            for (w=0; w<fnarr.length; w++){
              context.strokeStyle=(fnarr[w].color);
              fnarr[w].draw();
              context.strokeStyle="black";
            }
          }
          graph.curpos();

          // activate interest points if we are close to them
        });
        function redraw(){
          context.clearRect(0,0,canvas.width, canvas.height);
          graph.draw("dec");
          graph.drawZBar();
          for (w=0; w<fnarr.length; w++){
            context.strokeStyle=(fnarr[w].color);
            fnarr[w].draw();
            context.strokeStyle="black";
          }
        }
        function writeMessage(message){
          context.clearRect(0,0,canvas.width/2,25);
          context.font = "10pt Calibri";
          context.fillStyle = "black";
          context.fillText(message, 10, 20);
        }
        function writeMessageRight(message) {
          context.clearRect(canvas.width/2,0,canvas.width/2,25);
          context.font = "10pt Calibri";
          context.fillStyle = "black";
          context.fillText(message, canvas.width/2+10, 20);
        }
        function gcd(num1,num2){
          if (num2==0) {return num1;}
          if (num1 < num2) {return gcd(num2, num1);}
          return gcd(num1-num2, num2);
        }

        function writeNums(num, x, y){
          context.clearRect(x-5,y,x+5,y+10);
          context.font = "12pt Calibri";
          context.fillStyle = "black";
          context.fillText(num, x-7, y+15);
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
        function evaluatefn(sy,xval){
          form=new Array();
          //alert("start= "+xval);
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
              // alert(form);
              form.push(operation(sy[i], form.pop(), form.pop())); }
            //alert(form);
          }
          //alert("end= "+xval);
          return form[0];
        }
        function drawfunction(fn){
          sy=parseFN(fn);
          //alert(sy);
          var values=new Array();
          var pos=new Array();
          for(q=off; q<canvas.width-off; q+=1){
            xpos=q;
            curx=czoom*(xpos-cx)/width;
            //alert("cur= "+q);
            cury=evaluatefn(sy,curx)/czoom;
            ypos=(cy-width*cury);
            //alert(q+", "+ypos);
            if (ypos>off && ypos<canvas.height-off){
              values.push([curx,cury]);
              pos.push([q,Math.round(ypos)]);
            }
            ke=pos[0];  
            for(e=0; e<pos.length; e++){
              if(distance(ke[0],ke[1],pos[e][0],pos[e][1]) < 50){
                drawLine(ke[0],ke[1],pos[e][0],pos[e][1]);
              }
              else {context.fillRect(pos[e][0],pos[e][1]);} 
              ke=pos[e];
            }    
          } 
          return [values, pos];
        }
        function fn(fn, color){
          this.fn=fn;
          this.ret=drawfunction(fn);
          this.color=color;
          this.values=this.ret[0];
          this.pos=this.ret[1];
          this.draw=function(){
            //alert("here");
            this.ret=drawfunction(this.fn);
            this.values=this.ret[0];
            this.pos=this.ret[1];
            return this.values;
          }
        }
        function operation(op, lt, rt) {
          if (op=="+") {
            //alert("sum "+(rt+lt));
            return lt+rt;}
          if (op=="-") {return rt-lt;} 
          if (op=="*") {return lt*rt;}
          if (op=="/") {return rt/lt;}
          if (op=="^") {return Math.pow(rt,lt);}
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
        fns=["s","c","t","o","d","u","l"];
        opers=new Object();
        opers["^"]=1;
        opers["/"]=2;
        opers["*"]=2;
        opers["+"]=3;
        opers["-"]=3;
        ops=["sin", "cosec", "cos", "sec", "tan", "cot", "pi", "log"];
        //fnarr.push(new fn("sin(x)"));
        //fnarr[0].draw;

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
            if (fn.charAt(i)=="x")
            {
              //alert(tokens[tokens.length-2]);
              if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="p" || tokens[tokens.length-2]=="e" || tokens[tokens.length-2]=="x") {op.push("*"); }
              out.enqueue("x");
              //writeMessage("st= "+out.start+", end= "+out.end+", str="+out.toString());
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
              //alert("number "+fn.charAt(i));
              var nm=+temp;
              var j=2;
              temp=fn.substr(i,j);
              while (!isNaN(temp) && j+i<=fn.length){
                //alert(temp+", " + j);
                nm=+temp;
                j+=1;
                temp=fn.substr(i,j);
              }
              i=i+j-2;
              //alert("i="+i);
              out.enqueue(nm);
              /*if (i==1){
                writeMessage("st= "+out.length+", end= "+", str="+out.toString());
              }*/
            }
            else if (fns.indexOf(fn.charAt(i))!=-1)
            {
              op.push(fn.charAt(i));
            }
            else if (isOperator(fn.charAt(i)))
            {
              while (op.length!=0 && isOperator(op[op.length-1]))
              { //alert(op.toString());
                if(["+","-","*","/"].indexOf(fn.charAt(i))!=-1){
                  //context.fillText("op=" +op+", "+fn.charAt(i) +", out="+out.peek(), 10, 10*(i+1));
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
              //alert(fn.charAt(i));
              op.push(fn.charAt(i));
              //context.fillText(op.toString(), 300, (i+1)*10);
            }
            else if (fn.charAt(i)=="(")
            {
              if(!isNaN(tokens[tokens.length-2]) || tokens[tokens.length-2]=="x" || tokens[tokens.length-2]=="p" || tokens[tokens.length-2]=="e" || tokens[tokens.length-2]==")") {op.push("*");}
              op.push(fn.charAt(i));
            }
            else if (fn.charAt(i)==")")
            {
              while (op[op.length-1]!="(")
              {
                if (op.length==0)
                {
                  return "Error: mismatched parentheses";
                }
                out.enqueue(op.pop());
              }
              op.pop();
              if (fns.indexOf(op[op.length-1])!=-1) {out.enqueue(op.pop());}
            }
            else {return "Error: symbol not recognized";}
            //writeMessageRight(op.toString()+", "+out.toString());

          }
          //writeMessage(out.toString());

          while (op.length!=0)
          {
            //writeMessage("here");
            if (op[op.length-1]=="(")
            {
              return "Error: mismatched parentheses";
            }
            //writeMessage(op.peek());
            t=op.pop();
            //writeMessage(t);
            out.enqueue(t);

          }

          var tr=out.arr();
          return tr;
        }
        function queue(){
          this.ar=new Array();
          this.start=0;
          this.end=this.ar.length;
          this.enqueue=function(v){
            this.ar[this.end]=v;
            this.end+=1;
          }
          this.dequeue=function(){
            this.start+=1;
            return this.ar[this.start-1];
          }
          this.peek=function(){
            return this.ar[this.start];
          }
          this.arr=function(){
            var aa=new Array();
            for (i=this.start; i<this.end; i++)
            {
              aa[i-this.start]=this.ar[i];
            }
            return aa;
          }
          this.toString=function(){
            var str="";
            for (i=this.start; i<this.end; i+=1)
            {
              str+=this.ar[i]+", ";
            }
            return str;
          }
          this.empty=function(){
            if (this.end-this.start==0)
            {
              return true;
            }
            return false;
          }
        }
        function distance(x1, y1, x2, y2) {
          xdiff = x1 - x2;
          ydiff = y1 - y2;
          return Math.sqrt(xdiff * xdiff + ydiff * ydiff);
        }
      });
