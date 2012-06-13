
$(function() {
  // global drawing variables
  var canvas = $('#notepad')[0];
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var preshift=false;
  var mousedown=false;
  var curdraw=false;
  var asmd=false;
  var adding=false;
  var subtracting=false;
  var multiplying=false;
  var dividing=false;
  var comment=false;
  var commenting=false;
  var drawing=false;
  var num1="";
  var num2="";
  var notepad={
    curpage : -1,
    notes : new Array(),
    pixarr : new Array(),
    lheight : 20,
    margin : 50,
    com : new Array(),
    cline : -1,
    upper : 50,
    addpad : function(nt, cm, pix){
      this.notes=nt;
      this.com=cm;
      this.pixarr=pix;
      this.curpage=this.notes.length-1;
      this.createpage();
    },
    npad : function(){
             this.createpage();
           },
    drawlines : function(){
                  context.strokeStyle="#0083ad";
                  drawLine(this.margin-2, 0, this.margin-2, canvas.height);
                  drawLine(this.margin, 0, this.margin, canvas.height);
                  for(i=this.upper; i<canvas.height; i+=this.lheight){
                    drawLine(0, i, canvas.width, i);
                  }
                  context.strokeStyle="black";
                  context.font="9pt Calibri";
                  if(this.curpage==0){
                    $('.prev').hide();
                  }
                  else { $('.prev').show();}
                  context.fillText(""+(this.curpage+1), canvas.width-10, canvas.height-5);
                },
    createpage : function(){
                   if(this.curpage+1 < this.notes.length){
                     this.notes.splice(this.curpage+1, 0, new Array());
                     //alert(this.notes.toString());

                   }
                   context.clearRect(0,0,canvas.width, canvas.height);
                   this.curpage+=1;
                   this.drawlines();
                   this.notes[this.curpage]=new Array();
                   this.com[this.curpage]=new Array();
                   this.pixarr[this.curpage]=new Array();
                   $('#notes').attr("style", "background-color:transparent; position:absolute; left:"+(this.margin+5)+"px; top:"+(this.upper)+"px; width:"+(canvas.width-this.margin-20)+"px");
                   $('#notes').focus();
                 },
    addline : function(line){
                if(this.notes[this.curpage].length < (canvas.height-this.upper)/(this.lheight)-2){
                  this.notes[this.curpage].push(line);
                  this.displaylastline(line)
                }
                else {
                  this.createpage();
                  this.notes[this.curpage].push(line);
                  this.displaylastline(line);
                }
              },
    displaylastline : function(line){
                        context.font="10pt Courier";
                        context.fillText(line, this.margin+5, this.upper+this.notes[this.curpage].length*this.lheight-2);
                      },
    addf : function(n1, n2, sign){
             lt=1+Math.max(n1.length, n2.length);
             var ht="<table id=addtable border=0>\n";
             ht+="<tr>\n"
               for(i=0; i<lt-n1.length; i++){
                 ht+="<td> </td>\n";
               }
             for(i=0; i<n1.length; i++){
               ht+="<td>"+n1[i]+"</td>\n";
             }
             ht+="</tr>\n"
               ht+="<tr>\n"
               for(i=0; i<lt-n2.length; i++){
                 if(i==0){	
                   ht+="<td>"+sign+"</td>\n";
                 }
                 else {ht+="<td> </td>\n";}
               }
             for(i=0; i<n2.length; i++){
               ht+="<td>"+n2[i]+"</td>\n";
             }
             ht+="</tr>\n"
               ht+="<tr>\n"
               for(i=0; i<lt; i++){
                 ht+="<td><input type=text class=inps id=in"+i+" maxlength=1 style=\"width:15px; height:10px\"></td>\n";
               }
             ht+="</tr>\n"
               ht+="</table>";
             $('#note').append(ht);
             $('#addtable').attr("style", "background-color:transparent; font:10pt Courier; position:absolute; left:"+(this.margin+5)+"px; top:"+(this.upper+this.lheight*(this.notes[this.curpage].length)+5)+"px;");
             //alert($('#addtable').attr("style"));
             $("#in"+(lt-1)).select();
             $(".inps").keypress(function(e){
               var tot=""
               if (e.keyCode==13){
                 for(var i=0; i<lt; i++){
                   tot+=$("#in"+i).attr("value");
                 }
                 space=""
               for(i=0; i<lt-n1.length; i++){
                 space+=" ";
               }
             notepad.addline(" "+space+n1);
             space=""
               for(i=0; i<lt-n2.length; i++){
                 space+=" ";
               }
             notepad.addline(sign+""+space+n2);
             space=""
               for(i=0; i<lt-tot.length; i++){
                 space+=" ";
               }
             drawLine(notepad.margin+2, notepad.upper+notepad.notes[notepad.curpage].length*notepad.lheight, notepad.margin+2+10*(1+tot.length+space.length),notepad.upper+ notepad.notes[notepad.curpage].length*notepad.lheight);
             notepad.addline(" "+space+tot);
             $('#addtable').remove();
             $('#notes').show();
             $('#notes').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:"+(canvas.width-notepad.margin-20)+"px");
             $('#notes').attr("value","");
             $('#notes').focus();
             if (sign=="+"){
               adding=false;
             }
             else {subtracting=false;}
             asmd=false;
               }
             });
             for (var j=1; j<lt; j++)
             {
               $("#in"+j).keypress({j:j}, function(e){
                 if (e.keyCode!=13){
                   $("#in"+(e.data.j-1)).select();
                 }
               });
             }

           },
    multf : function(n1, n2){
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
              $('#note').append(ht);
              $('#addtable').attr("style", "background-color:transparent; font:10pt Courier; position:absolute; left:"+(this.margin+5)+"px; top:"+(this.upper+this.lheight*(this.notes[this.curpage].length)+5)+"px;");
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
                    for(i=0; i<lt-n1.length; i++){
                      tot+=" ";
                    }
                    notepad.addline("  "+tot+n1);
                    tot=""
                  for(i=0; i<lt-n2.length; i++){
                    tot+=" ";
                  }
                notepad.addline("x "+tot+n2);
                drawLine(notepad.margin+2, notepad.upper+notepad.notes[notepad.curpage].length*notepad.lheight, notepad.margin+2+10*(2+tot.length),notepad.upper+ notepad.notes[notepad.curpage].length*notepad.lheight);
                tot=""
                  for(var i=0; i<lt-1; i++){
                    tot+=$("#in_0_"+i).attr("value");
                  }
                var space=""
                  for(var i=0; i<lt-tot.length; i++){
                    space+=" ";
                  }
                notepad.addline("= "+space+tot);
                $('#addtable').remove();
                $('#notes').show();
                $('#notes').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:"+(canvas.width-notepad.margin-20)+"px");
                $('#notes').attr("value","");
                $('#notes').focus();
                multiplying=false;
                asmd=false;
                  }

                });
              }
              else {
                $(".inps").keypress(function(e){
                  var tot="";
                  if (e.keyCode==13){
                    for(i=0; i<lt-n1.length; i++){
                      tot+=" ";
                    }
                    notepad.addline(" "+tot+n1);
                    tot=""
                  for(i=0; i<lt-n2.length; i++){
                    tot+=" ";
                  }
                notepad.addline("x"+tot+n2);
                drawLine(notepad.margin+2, notepad.upper+notepad.notes[notepad.curpage].length*notepad.lheight, notepad.margin+2+10*(tot.length+n2.length+1),notepad.upper+ notepad.notes[notepad.curpage].length*notepad.lheight);
                tot=""
                  for(var j=0; j<n2.length; j++){
                    tot="";
                    for (i=0; i<n1.length+j+1; i++){
                      tot+=$("#in_"+j+"_"+i).attr("value");
                    }
                    var space="";
                    for (i=0; i<lt-tot.length; i++){
                      space+=" ";
                    }
                    if (j==0) {tot=" "+space+tot;}
                    else {tot="+"+space+tot;}
                    notepad.addline(tot);
                  }
                drawLine(notepad.margin+2, notepad.upper+notepad.notes[notepad.curpage].length*notepad.lheight, notepad.margin+2+10*(tot.length),notepad.upper+ notepad.notes[notepad.curpage].length*notepad.lheight);
                tot="";
                for(var i=0; i<lt; i++){
                  tot+=$("#in"+i).attr("value");
                }
                space="";
                for(var i=0; i<lt-tot.length; i++){
                  space+=" ";
                }
                notepad.addline(" "+space+tot);
                $('#addtable').remove();
                $('#notes').show();
                $('#notes').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:"+(canvas.width-notepad.margin-20)+"px");
                $('#notes').attr("value","");
                $('#notes').focus();
                multiplying=false;
                asmd=false;
                  }
                });
              }
              for (var j=1; j<lt; j++){
                $("#in"+j).keypress({j:j}, function(e){
                  if (e.keyCode!=13){
                    $("#in"+(e.data.j-1)).select();
                  }
                });
              }
              for(var j=0; j<n2.length; j++){
                for(var i=1; i<n1.length+j+1; i++){
                  $("#in_"+j+"_"+i).keypress({j:j, i:i}, function(e){
                    if (e.keyCode!=13){
                      $("#in_"+(e.data.j)+"_"+(e.data.i-1)).select();
                    }
                  });
                }
              }

            },
    comm : function(cline){
             this.cline=cline;
             $('#comment').show();
             if(this.com[this.curpage][this.cline]!=null){
               $('#comment').attr("value",this.com[this.curpage][this.cline]);
             }
             $('#comment').attr("style", "position:absolute; left:"+(this.margin)+"px; top:"+(this.upper+cline*this.lheight)+"px;");
             commenting=true;
             $('#comment').focus();
           },
    doop : function(cline){
             ops=["+", "-", "*"];
             exp=[];
             op="";
             for(i=0; i < ops.length; i++){
               if(cline.split(ops[i]).length==2){
                 if( exp.length!=0) {return false;}
                 else {
                   exp=cline.split(ops[i]);
                   op=ops[i];
                 }
               }
             }
             exp[0]=exp[0].replace(/^\s+|\s+$/g, '');
             exp[1]=exp[1].replace(/^\s+|\s+$/g, '');
             if(exp.length==0) {return false;}
             if(isNaN(Number(exp[0])) || isNaN(Number(exp[1]))){
               return false;
             }
             asmd=true;
             $("#notes").attr("value", "");
             $("#notes").hide();
             if(op=="+"){
               adding=true;
               this.addf(exp[0], exp[1], "+");
             } 
             if(op=="-"){
               subtracting=true;
               this.addf(exp[0], exp[1], "-");
             }
             if(op=="*"){
               multiplying=true;
               this.multf(exp[0], exp[1]);
             }
           },



               
    nppage : function(next){
               if(this.notes[this.curpage+next]!=null && this.curpage+next!=this.notes.length-1){
                 $('#notes').hide();
                 $('.plug').hide();
                 $('.tbreak').hide();
                 $('.placeholder').show();
               }
               else if(this.curpage+next==this.notes.length-1){
                 $('#notes').show(); 
                 $('.plug').show(); 
                 $('.tbreak').show();
                 $('.placeholder').hide();
               }
               if(this.curpage+next >0){
                 $(".cmt"+this.curpage).hide();
                 if(asmd){
                   $('#num1').attr("value", "");
                   $('#num2').attr("value", "");
                   $('#num1').hide();
                   $('#num2').hide();
                   $('#num1lab').remove();
                   $('#num2lab').remove();
                   $('#addtable').remove();
                   asmd=false;
                   adding=false;
                   multiplying=false;
                   subtracting=false;
                   dividing=false;
                   commenting=false;
                   $('#comment').attr("value","");
                 }
               }
               if(this.notes[this.curpage+next]==null && this.curpage+next >= 0){
                 this.createpage();
               }
               else if(this.curpage+next < 0) {alert("already at first page");}
               else {
                 this.curpage+=next;
                 context.clearRect(0,0,canvas.width, canvas.height);
                 this.drawlines();
                 for(var i=0; i < this.notes[this.curpage].length; i++){
                   context.font="10pt Courier";
                   context.fillText(this.notes[this.curpage][i], this.margin+5, this.upper+(i+1)*this.lheight-2);  
                 } 
                 context.lineWidth=2;
                 for(var i=0; i < this.pixarr[this.curpage].length; i++){
                   for(var j=1; j< this.pixarr[this.curpage][i].length; j++){
                     drawLine(this.pixarr[this.curpage][i][j-1][0], this.pixarr[this.curpage][i][j-1][1], this.pixarr[this.curpage][i][j][0], this.pixarr[this.curpage][i][j][1]);   
                   }
                 } 
                 $(".cmt"+this.curpage).show();
                 context.lineWidth=1;
                 $('#notes').focus();
               }
             }
  }
  notepad.npad();
  $('#notes').focus();


  $('#notepad').mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    if(commenting){
      $("#cmt_"+notepad.curpage+"_"+notepad.cline).remove();
      notepad.com[notepad.curpage][notepad.cline]=$('#comment').attr("value");
      if($('#comment').attr("value")!=""){
        var htm="<div class=cmt"+notepad.curpage+" id=cmt_"+notepad.curpage+"_"+notepad.cline+" style=\"position:absolute; left:"+(notepad.margin-20)+"px; top:"+(notepad.cline*notepad.lheight+notepad.upper+4)+"px;\">\n";
        htm+="<i class=\"icon-comment\"></i>"
        htm+="</div>";
        $('#note').append(htm);
        $("#cmt_"+notepad.curpage+"_"+notepad.cline).click({cline:notepad.cline}, function(e){
          notepad.comm(e.data.cline);
        });
      }
      $('#comment').attr("value","");
      $('#comment').attr("style","display:none;");
      commenting=false;
    }
    if(downy < canvas.height-20 && downx > 50 && downy > 50 && !commenting){
      $('#note').css('cursor','pointer'); 
      notepad.pixarr[notepad.curpage].push(new Array());
      notepad.pixarr[notepad.curpage][notepad.pixarr[notepad.curpage].length-1].push([downx, downy]);
      curdraw=true;
    }
    mousedown=true;
  });
  $('.prev').mousedown(function(e){
    notepad.nppage(-1);
  });

  $('.next').mousedown(function(e){
    notepad.nppage(1);
  });
  $('#notepad').mouseup(function (e) { 
    mousedown=false;
    drawing=false;
    curdraw=false;
    $('#note').css('cursor','default'); 
    $('#notes').focus();
  });

  $('#notepad').scroll(function (e) { 

  });
  $('#notepad').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    var offset = $('#notepad').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);

    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
    if(curdraw && mousey < canvas.height-20 && mousex > 50 && mousey > 50){
      drawing=true;
      context.lineWidth=2;
      cpa=notepad.pixarr[notepad.curpage];
      drawLine(cpa[cpa.length-1][cpa[cpa.length-1].length-1][0], cpa[cpa.length-1][cpa[cpa.length-1].length-1][1], mousex,mousey);
      notepad.pixarr[notepad.curpage][notepad.pixarr[notepad.curpage].length-1].push([mousex, mousey]);
      context.lineWidth=1;
    }
  });
  $('#notepad').dblclick(function(e){
    if(notepad.notes.length-1!=notepad.curpage && downy > notepad.upper && !drawing && downx<notepad.margin){
      var cline=Math.floor((downy-notepad.upper)/notepad.lheight);
      notepad.comm(cline);
    }
  });
  $('#notes').keydown(function(e){
    if (e.keyCode==16){
      preshift=true;
    }
  });
  $('#notes').keypress(function(e){
    if (e.keyCode==13){
      if(preshift){
        notepad.doop($('#notes').attr("value"));
      }
      else{
        notepad.addline($('#notes').attr("value"));
        $('#notes').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:"+(canvas.width-notepad.margin-20)+"px");
        $('#notes').attr("value","");
      }
      //alert($('#notes').attr("style"));
    }
  });
  $('#notes').keyup(function(e){
    if (e.keyCode==16){
      preshift=false;
    }
  });

  $('#add').click(function(){
    if(!asmd){
      $('#num1lab').remove();
      $('#num2lab').remove();
      notepad.addline(" ");
      $("#notes").hide();
      $("#num1").show();
      $("#num2").show();
      $('#num1').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:150px");
      $('#num2').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px");
      $("#note").append("<label id=num1lab for=num1 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(3+notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:150px\">1st Number =</label>\n<label id=num2lab for=num2 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(3+notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px\">2nd Number =</label>");
      $("#num1").focus();
      asmd=true;
      adding=true;
    }
  });
  $('#sub').click(function(){
    if(!asmd){
      $('#num1lab').remove();
      $('#num2lab').remove();
      notepad.addline(" ");
      $("#notes").hide();
      $("#num1").show();
      $("#num2").show();
      $('#num1').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:150px");
      $('#num2').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px");
      $("#note").append("<label id=num1lab for=num1 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(3+notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:150px\">1st Number =</label>\n<label id=num2lab for=num2 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(3+notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px\">2nd Number =</label>");
      $("#num1").focus();
      asmd=true;
      subtracting=true;
    }
  });
  $('#mult').click(function(){
    if(!asmd){
      $('#num1lab').remove();
      $('#num2lab').remove();
      notepad.addline(" ");
      $("#notes").hide();
      $("#num1").show();
      $("#num2").show();
      $('#num1').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length))+"px; width:150px");
      $('#num2').attr("style", "background-color:transparent; position:absolute; left:"+(notepad.margin+105)+"px; top:"+(notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px");
      $("#note").append("<label id=num1lab for=num1 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(notepad.upper+notepad.lheight*(notepad.notes[notepad.curpage].length)+3)+"px; width:150px\">1st Number =</label>\n<label id=num2lab for=num2 style=\"background-color:transparent; font:10pt Courier; position:absolute; left:"+(notepad.margin+5)+"px; top:"+(3+notepad.upper+notepad.lheight*(2+notepad.notes[notepad.curpage].length))+"px; width:150px\">2nd Number =</label>");
      $("#num1").focus();
      asmd=true;
      multiplying=true;
    }
  });
  $('#num1').keypress(function(e){
    if (e.keyCode==13){
      $('#num2').focus();
    }
  });
  $('#num2').keypress(function(e){
    if (e.keyCode==13){
      var num1=$('#num1').attr("value");
      var num2=$('#num2').attr("value");
      if(adding) {notepad.addf(num1, num2, "+");}
      else if(multiplying) {notepad.multf(num1, num2);}
      else if(subtracting) {notepad.addf(num1, num2, "-");}
      $("#num1").attr("value","");
      $("#num2").attr("value","");
      $("#num1").hide();
      $("#num2").hide();
      $("#num1lab").remove();
      $("#num2lab").remove();
    }
  });

  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }
});
