$(function(){function v(a,c,d,e){b.beginPath(),b.moveTo(a,c),b.lineTo(d,e),b.stroke(),b.closePath()}var a=$("#notepad")[0],b=a.getContext("2d"),c,d,e,f,g=!1,h=!1,j=!1,k=!1,l=!1,m=!1,n=!1,o=!1,p=!1,q=!1,r=!1,s="",t="",u={curpage:-1,notes:new Array,pixarr:new Array,lheight:20,margin:50,com:new Array,cline:-1,upper:50,addpad:function(a,b,c){this.notes=a,this.com=b,this.pixarr=c,this.curpage=this.notes.length-1,this.createpage()},npad:function(){this.createpage()},drawlines:function(){b.strokeStyle="#0083ad",v(this.margin-2,0,this.margin-2,a.height),v(this.margin,0,this.margin,a.height);for(i=this.upper;i<a.height;i+=this.lheight)v(0,i,a.width,i);b.strokeStyle="black",b.font="9pt Calibri",this.curpage==0?$(".prev").hide():$(".prev").show(),b.fillText(""+(this.curpage+1),a.width-10,a.height-5)},createpage:function(){this.curpage+1<this.notes.length&&this.notes.splice(this.curpage+1,0,new Array),b.clearRect(0,0,a.width,a.height),this.curpage+=1,this.drawlines(),this.notes[this.curpage]=new Array,this.com[this.curpage]=new Array,this.pixarr[this.curpage]=new Array,$("#notes").attr("style","background-color:transparent; position:absolute; left:"+(this.margin+5)+"px; top:"+this.upper+"px; width:"+(a.width-this.margin-20)+"px"),$("#notes").focus()},addline:function(b){this.notes[this.curpage].length<(a.height-this.upper)/this.lheight-2?(this.notes[this.curpage].push(b),this.displaylastline(b)):(this.createpage(),this.notes[this.curpage].push(b),this.displaylastline(b))},displaylastline:function(a){b.font="10pt Courier",b.fillText(a,this.margin+5,this.upper+this.notes[this.curpage].length*this.lheight-2)},addf:function(b,c,d){lt=1+Math.max(b.length,c.length);var e="<table id=addtable border=0>\n";e+="<tr>\n";for(i=0;i<lt-b.length;i++)e+="<td> </td>\n";for(i=0;i<b.length;i++)e+="<td>"+b[i]+"</td>\n";e+="</tr>\n",e+="<tr>\n";for(i=0;i<lt-c.length;i++)i==0?e+="<td>"+d+"</td>\n":e+="<td> </td>\n";for(i=0;i<c.length;i++)e+="<td>"+c[i]+"</td>\n";e+="</tr>\n",e+="<tr>\n";for(i=0;i<lt;i++)e+="<td><input type=text class=inps id=in"+i+' maxlength=1 style="width:15px; height:10px"></td>\n';e+="</tr>\n",e+="</table>",$("#note").append(e),$("#addtable").attr("style","background-color:transparent; font:10pt Courier; position:absolute; left:"+(this.margin+5)+"px; top:"+(this.upper+this.lheight*this.notes[this.curpage].length+5)+"px;"),$("#in"+(lt-1)).select(),$(".inps").keypress(function(e){var f="";if(e.keyCode==13){for(var g=0;g<lt;g++)f+=$("#in"+g).attr("value");space="";for(g=0;g<lt-b.length;g++)space+=" ";u.addline(" "+space+b),space="";for(g=0;g<lt-c.length;g++)space+=" ";u.addline(d+""+space+c),space="";for(g=0;g<lt-f.length;g++)space+=" ";v(u.margin+2,u.upper+u.notes[u.curpage].length*u.lheight,u.margin+2+10*(1+f.length+space.length),u.upper+u.notes[u.curpage].length*u.lheight),u.addline(" "+space+f),$("#addtable").remove(),$("#notes").show(),$("#notes").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+5)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:"+(a.width-u.margin-20)+"px"),$("#notes").attr("value",""),$("#notes").focus(),d=="+"?l=!1:m=!1,k=!1}});for(var f=1;f<lt;f++)$("#in"+f).keypress({j:f},function(a){a.keyCode!=13&&$("#in"+(a.data.j-1)).select()})},multf:function(b,c){lt=1+b.length+c.length;var d="<table id=addtable border=0>\n";d+="<tr>\n";for(f=0;f<lt-b.length;f++)d+="<td> </td>\n";for(f=0;f<b.length;f++)d+="<td>"+b[f]+"</td>\n";d+="</tr>\n",d+="<tr>\n";for(f=0;f<lt-c.length;f++)f==0?d+="<td>x</td>\n":d+="<td> </td>\n";for(f=0;f<c.length;f++)d+="<td>"+c[f]+"</td>\n";d+="</tr>\n";for(e=0;e<c.length;e++){d+="<tr>\n";for(f=0;f<lt-(b.length+e+1);f++)f==0&&e!=0?d+="<td>+</td>\n":d+="<td> </td>\n";for(f=0;f<b.length+e+1;f++)d+="<td><input type=text class=inps"+e+" id=in_"+e+"_"+f+' maxlength=1 style="width:15px; height:10px"></td>\n';d+="</tr>\n"}if(c.length>1)for(f=0;f<lt;f++)d+="<td><input type=text class=inps id=in"+f+' maxlength=1 style="width:15px; height:10px"></td>\n';d+="</tr>\n",d+="</table>",$("#note").append(d),$("#addtable").attr("style","background-color:transparent; font:10pt Courier; position:absolute; left:"+(this.margin+5)+"px; top:"+(this.upper+this.lheight*this.notes[this.curpage].length+5)+"px;"),$("#in_0_"+b.length).select();for(e=0;e<c.length;e++)e==c.length-1?$(".inps"+e).keypress(function(a){a.keyCode==13&&$("#in"+(lt-1)).select()}):$(".inps"+e).keypress({j:e},function(a){if(a.keyCode==13){$("#in_"+(a.data.j+1)+"_"+b.length).select();for(f=0;f<e;f++)$("#in_"+(a.data.j+1)+"_"+(b.length+1+f)).attr("value","0")}});c.length==1?$(".inps0").keypress(function(d){var e="";if(d.keyCode==13){for(f=0;f<lt-b.length;f++)e+=" ";u.addline("  "+e+b),e="";for(f=0;f<lt-c.length;f++)e+=" ";u.addline("x "+e+c),v(u.margin+2,u.upper+u.notes[u.curpage].length*u.lheight,u.margin+2+10*(2+e.length),u.upper+u.notes[u.curpage].length*u.lheight),e="";for(var f=0;f<lt-1;f++)e+=$("#in_0_"+f).attr("value");var g="";for(var f=0;f<lt-e.length;f++)g+=" ";u.addline("= "+g+e),$("#addtable").remove(),$("#notes").show(),$("#notes").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+5)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:"+(a.width-u.margin-20)+"px"),$("#notes").attr("value",""),$("#notes").focus(),n=!1,k=!1}}):$(".inps").keypress(function(d){var e="";if(d.keyCode==13){for(h=0;h<lt-b.length;h++)e+=" ";u.addline(" "+e+b),e="";for(h=0;h<lt-c.length;h++)e+=" ";u.addline("x"+e+c),v(u.margin+2,u.upper+u.notes[u.curpage].length*u.lheight,u.margin+2+10*(e.length+c.length+1),u.upper+u.notes[u.curpage].length*u.lheight),e="";for(var f=0;f<c.length;f++){e="";for(h=0;h<b.length+f+1;h++)e+=$("#in_"+f+"_"+h).attr("value");var g="";for(h=0;h<lt-e.length;h++)g+=" ";f==0?e=" "+g+e:e="+"+g+e,u.addline(e)}v(u.margin+2,u.upper+u.notes[u.curpage].length*u.lheight,u.margin+2+10*e.length,u.upper+u.notes[u.curpage].length*u.lheight),e="";for(var h=0;h<lt;h++)e+=$("#in"+h).attr("value");g="";for(var h=0;h<lt-e.length;h++)g+=" ";u.addline(" "+g+e),$("#addtable").remove(),$("#notes").show(),$("#notes").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+5)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:"+(a.width-u.margin-20)+"px"),$("#notes").attr("value",""),$("#notes").focus(),n=!1,k=!1}});for(var e=1;e<lt;e++)$("#in"+e).keypress({j:e},function(a){a.keyCode!=13&&$("#in"+(a.data.j-1)).select()});for(var e=0;e<c.length;e++)for(var f=1;f<b.length+e+1;f++)$("#in_"+e+"_"+f).keypress({j:e,i:f},function(a){a.keyCode!=13&&$("#in_"+a.data.j+"_"+(a.data.i-1)).select()})},comm:function(a){this.cline=a,$("#comment").show(),this.com[this.curpage][this.cline]!=null&&$("#comment").attr("value",this.com[this.curpage][this.cline]),$("#comment").attr("style","position:absolute; left:"+this.margin+"px; top:"+(this.upper+a*this.lheight)+"px;"),q=!0,$("#comment").focus()},doop:function(a){ops=["+","-","*"],exp=[],op="";for(i=0;i<ops.length;i++)if(a.split(ops[i]).length==2){if(exp.length!=0)return!1;exp=a.split(ops[i]),op=ops[i]}exp[0]=exp[0].replace(/^\s+|\s+$/g,""),exp[1]=exp[1].replace(/^\s+|\s+$/g,"");if(exp.length==0)return!1;if(isNaN(Number(exp[0]))||isNaN(Number(exp[1])))return!1;k=!0,$("#notes").attr("value",""),$("#notes").hide(),op=="+"&&(l=!0,this.addf(exp[0],exp[1],"+")),op=="-"&&(m=!0,this.addf(exp[0],exp[1],"-")),op=="*"&&(n=!0,this.multf(exp[0],exp[1]))},nppage:function(c){this.notes[this.curpage+c]!=null&&this.curpage+c!=this.notes.length-1?($("#notes").hide(),$(".plug").hide(),$(".tbreak").hide(),$(".placeholder").show()):this.curpage+c==this.notes.length-1&&($("#notes").show(),$(".plug").show(),$(".tbreak").show(),$(".placeholder").hide()),this.curpage+c>0&&($(".cmt"+this.curpage).hide(),k&&($("#num1").attr("value",""),$("#num2").attr("value",""),$("#num1").hide(),$("#num2").hide(),$("#num1lab").remove(),$("#num2lab").remove(),$("#addtable").remove(),k=!1,l=!1,n=!1,m=!1,o=!1,q=!1,$("#comment").attr("value","")));if(this.notes[this.curpage+c]==null&&this.curpage+c>=0)this.createpage();else if(this.curpage+c<0)alert("already at first page");else{this.curpage+=c,b.clearRect(0,0,a.width,a.height),this.drawlines();for(var d=0;d<this.notes[this.curpage].length;d++)b.font="10pt Courier",b.fillText(this.notes[this.curpage][d],this.margin+5,this.upper+(d+1)*this.lheight-2);b.lineWidth=2;for(var d=0;d<this.pixarr[this.curpage].length;d++)for(var e=1;e<this.pixarr[this.curpage][d].length;e++)v(this.pixarr[this.curpage][d][e-1][0],this.pixarr[this.curpage][d][e-1][1],this.pixarr[this.curpage][d][e][0],this.pixarr[this.curpage][d][e][1]);$(".cmt"+this.curpage).show(),b.lineWidth=1,$("#notes").focus()}}};u.npad(),$("#notes").focus(),$("#notepad").mousedown(function(b){e=c,f=d;if(q){$("#cmt_"+u.curpage+"_"+u.cline).remove(),u.com[u.curpage][u.cline]=$("#comment").attr("value");if($("#comment").attr("value")!=""){var g="<div class=cmt"+u.curpage+" id=cmt_"+u.curpage+"_"+u.cline+' style="position:absolute; left:'+(u.margin-20)+"px; top:"+(u.cline*u.lheight+u.upper+4)+'px;">\n';g+='<i class="icon-comment"></i>',g+="</div>",$("#note").append(g),$("#cmt_"+u.curpage+"_"+u.cline).click({cline:u.cline},function(a){u.comm(a.data.cline)})}$("#comment").attr("value",""),$("#comment").attr("style","display:none;"),q=!1}f<a.height-20&&e>50&&f>50&&!q&&($("#note").css("cursor","pointer"),u.pixarr[u.curpage].push(new Array),u.pixarr[u.curpage][u.pixarr[u.curpage].length-1].push([e,f]),j=!0),h=!0}),$(".prev").mousedown(function(a){u.nppage(-1)}),$(".next").mousedown(function(a){u.nppage(1)}),$("#notepad").mouseup(function(a){h=!1,r=!1,j=!1,$("#note").css("cursor","default"),$("#notes").focus()}),$("#notepad").scroll(function(a){}),$("#notepad").mousemove(function(e){var f=$("#notepad").offset(),g=Math.round(f.left),h=Math.round(f.top);c=e.pageX-g,d=e.pageY-h,j&&d<a.height-20&&c>50&&d>50&&(r=!0,b.lineWidth=2,cpa=u.pixarr[u.curpage],v(cpa[cpa.length-1][cpa[cpa.length-1].length-1][0],cpa[cpa.length-1][cpa[cpa.length-1].length-1][1],c,d),u.pixarr[u.curpage][u.pixarr[u.curpage].length-1].push([c,d]),b.lineWidth=1)}),$("#notepad").dblclick(function(a){if(u.notes.length-1!=u.curpage&&f>u.upper&&!r&&e<u.margin){var b=Math.floor((f-u.upper)/u.lheight);u.comm(b)}}),$("#notes").keydown(function(a){a.keyCode==16&&(g=!0)}),$("#notes").keypress(function(b){b.keyCode==13&&(g?u.doop($("#notes").attr("value")):(u.addline($("#notes").attr("value")),$("#notes").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+5)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:"+(a.width-u.margin-20)+"px"),$("#notes").attr("value","")))}),$("#notes").keyup(function(a){a.keyCode==16&&(g=!1)}),$("#add").click(function(){k||($("#num1lab").remove(),$("#num2lab").remove(),u.addline(" "),$("#notes").hide(),$("#num1").show(),$("#num2").show(),$("#num1").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:150px"),$("#num2").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*(2+u.notes[u.curpage].length))+"px; width:150px"),$("#note").append('<label id=num1lab for=num1 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(3+u.upper+u.lheight*u.notes[u.curpage].length)+'px; width:150px">1st Number =</label>\n<label id=num2lab for=num2 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(3+u.upper+u.lheight*(2+u.notes[u.curpage].length))+'px; width:150px">2nd Number =</label>'),$("#num1").focus(),k=!0,l=!0)}),$("#sub").click(function(){k||($("#num1lab").remove(),$("#num2lab").remove(),u.addline(" "),$("#notes").hide(),$("#num1").show(),$("#num2").show(),$("#num1").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:150px"),$("#num2").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*(2+u.notes[u.curpage].length))+"px; width:150px"),$("#note").append('<label id=num1lab for=num1 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(3+u.upper+u.lheight*u.notes[u.curpage].length)+'px; width:150px">1st Number =</label>\n<label id=num2lab for=num2 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(3+u.upper+u.lheight*(2+u.notes[u.curpage].length))+'px; width:150px">2nd Number =</label>'),$("#num1").focus(),k=!0,m=!0)}),$("#mult").click(function(){k||($("#num1lab").remove(),$("#num2lab").remove(),u.addline(" "),$("#notes").hide(),$("#num1").show(),$("#num2").show(),$("#num1").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length)+"px; width:150px"),$("#num2").attr("style","background-color:transparent; position:absolute; left:"+(u.margin+105)+"px; top:"+(u.upper+u.lheight*(2+u.notes[u.curpage].length))+"px; width:150px"),$("#note").append('<label id=num1lab for=num1 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(u.upper+u.lheight*u.notes[u.curpage].length+3)+'px; width:150px">1st Number =</label>\n<label id=num2lab for=num2 style="background-color:transparent; font:10pt Courier; position:absolute; left:'+(u.margin+5)+"px; top:"+(3+u.upper+u.lheight*(2+u.notes[u.curpage].length))+'px; width:150px">2nd Number =</label>'),$("#num1").focus(),k=!0,n=!0)}),$("#num1").keypress(function(a){a.keyCode==13&&$("#num2").focus()}),$("#num2").keypress(function(a){if(a.keyCode==13){var b=$("#num1").attr("value"),c=$("#num2").attr("value");l?u.addf(b,c,"+"):n?u.multf(b,c):m&&u.addf(b,c,"-"),$("#num1").attr("value",""),$("#num2").attr("value",""),$("#num1").hide(),$("#num2").hide(),$("#num1lab").remove(),$("#num2lab").remove()}})})