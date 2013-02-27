
function setUpDataGr(cname, tname) {
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  var canvas = $("#"+cname)[0];
  var table = tname;
  if(canvas == undefined) { return undefined; }
  var ht = canvas.height;
  var wt = canvas.width; 
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var mousedown=false;

  var grph={
    mg : 50,
    type : "basicbar",
    scale : 30,
    color : ["red", "green", "blue", "orange", "yellow", "gray"],
    edit : false,
    divs : 10,
    dir : 'x',
    head : "",
    start : 0,
    table : new Array(),
    tally : [],
    divsedit : false,
    setEditable : function(edit){
              this.edit=edit;
    },
    setDivsEditable : function(divsedit){
              this.divsedit=divsedit;
    },
    setType : function(type){
               this.type=type;
            },
    setDivs : function(divs){
                this.divs=divs;
            },
    setScale : function(scale){
               this.scale=scale;
             },
    setDir : function(dir){
               this.dir=dir;
             },
    setHead : function(head){
                this.head=head;
              },
    setStart : function(start){
                 this.start=start;
               },
    drawBones : function(){
                  context.fillStyle="black";
                  drawLine(this.mg, ht-this.mg, this.mg, 0);
                  drawLine(wt, ht-this.mg, this.mg, ht-this.mg);
                  for (i = 0; i <= ((ht-this.mg) / this.scale) ; i++) {
                    drawLine(this.mg, ht-this.mg-i*this.scale,this.mg+5, ht-this.mg-i*this.scale);
                    context.textAlign="right";
                    context.fillText(this.divs*i, this.mg-1, ht-this.mg-i*this.scale+8); 
                  }
                },
    fromTable : function(){
                  $("#"+table+" tr").each(function() {
                    var arrayOfThisRow = [];
                    var tableData = $(this).find('input');
                    if (tableData.length > 0) {
                      tableData.each(function() { arrayOfThisRow.push($(this).attr("value")); });
                      grph.table.push(arrayOfThisRow);
                    }
                  });
                },
    drawInitialPictogram : function(imurl){
                      this.image=imurl;
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      mu=20;
                      html="";
                      for(i=0; i<this.table.length; i++){
                        for(j=0; j<parseInt(this.table[i][1]); j++){
                          if(parseInt(this.table[i][1])-this.divs >= this.divs){
                            if((j+1)%this.divs==0){
                              html+="<i class=\"pict "+imurl+"\" id=pict_"+i+"_"+((j+1)/this.divs)+" style=\"position:absolute; top:"+(y+i*2*y)+"px; left:"+(x+mu*(j+1)/this.divs)+"px;\"></i>\n";
                            }
                          }
                          else { html+="<i class=\"half_pict "+imurl+"\" id=pict_"+i+"_"+Math.ceil((j+1)/this.divs)+" style=\"position:absolute; top:"+(y+i*2*y)+"px; left:"+(x+mu*Math.ceil((j+1)/this.divs))+"px;\"></i>\n";}
                        }
                      }
                      $("#pict").append(html);
                    }, 
    addPictogram : function(index){
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      html="<i class=\"pict "+this.image+"\" id=pict_"+index+"_"+(1+parseInt(this.table[index][1])/this.divs)+" style=\"position:absolute; top:"+(y+index*2*y)+"px; "+(x+mu*(1+Math.ceil(parseInt(this.table[index][1])/this.divs)))+"px;\"></i>\n";
                      this.table[index][1]=""+(parseInt(this.table[index][1])+this.divs);
                      cor=true;
                      for(i=0; i<Math.ceil(parseInt(this.table[index][i])/this.divs)-1; i++){
                        if($("#pict_"+index+"_"+(i+1)).attr("class")=="half_pict "+this.image){
                          cor=false;
                          break;
                        }
                      }
                      if (!cor) {
                        this.table[index][1]="n/a";
                      }
                   },
    addHalfPictogram : function(index){
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      html="<i class=\"half_pict "+this.image+"\" id=pict_"+index+"_"+(parseInt(this.table[index][1])/this.divs)+" style=\"position:absolute; top:"+(y+index*2*y)+"px; "+(x+mu*Math.ceil(parseInt(this.table[index][1])/this.divs))+"px;\"></i>\n";
                      this.table[index][1]=""+(parseInt(this.table[index][1])+this.divs/2)
                      cor=true;
                      for(i=0; i<Math.ceil(parseInt(this.table[index][i])/this.divs)-1; i++){
                        if($("#pict_"+index+"_"+(i+1)).attr("class")=="half_pict "+this.image){
                          cor=false;
                          break;
                        }
                      }
                      if (!cor) {
                        this.table[index][1]="n/a";
                      }
                   },
    removePictogram : function(index){
                        if($("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).attr("class")=="half_pict "+this.image) {this.table[index][i]=""+parseInt(this.table[index][i])-this.divs/2;}
                        if($("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).attr("class")=="pict "+this.image) {this.table[index][i]=""+parseInt(this.table[index][i])-this.divs/2;}
                        $("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).remove();
                      },

    preInitialTally : function(){
                        for(i=0; i<this.table.length; i++){
                          this.tally[i]=new Array();
                          for(k=0; k < parseInt(this.table[i][1]); k++){
                            if((k+1) % 5!=0){
                              this.tally[i].push('|');
                            }
                            else{ this.tally[i].push('/'); }
                          }
                        }
                        
                      },
    drawTallyMarks : function(){
                       drawLine(wt/4, 0, wt/4, ht);
                       if(this.edit){
                        drawLine(3*wt/4, 0, 3*wt/4, ht);
                       }
                       x=10+wt/4;
                       y=(ht/this.table.length)/2;
                       mu=7;
                       su=10;
                       for(i=0; i<this.table.length; i++){
                         drawLine(0, (i+1)*(ht/this.table.length), wt, (i+1)*(ht/this.table.length));
                         context.textAlign="center";
                         context.fillStyle=COLOR[i % COLOR.length];
                         context.font="12pt Calibri";
                         context.fillText(this.table[i][0], wt/8, y+i*(ht/this.table.length)+3);
                         context.strokeStyle="black";
                         context.textAlign="left";
                         ct=0;
                         for(j=0; j < this.tally[i].length; j++){
                           context.strokeStyle=COLOR[i % COLOR.length];
                           if(this.tally[i][j]=='|'){
                             drawLine(x+j*mu, y+i*(ht/this.table.length)-su, x+j*mu, y+i*(ht/this.table.length)+su);
                             ct+=1;
                           }
                           else{
                             drawLine(x+(j)*mu, y+i*(ht/this.table.length)-su, x+(j-ct-1)*mu, y+i*(ht/this.table.length)+su);
                             ct=0;
                           }
                           context.strokeStyle="black";
                         }    
                       }

                     },

    addLine : function(index){
                this.tally[index].push('|');
                ret=parseInt(this.table[index][1])+1;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  }
                }
                this.table[index][1]=ret;
              },
    addSlash : function(index){
                this.tally[index].push('/');
                ret=parseInt(this.table[index][1])+1;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  }
                }
                this.table[index][1]=ret;
              },
    remLast : function(index){
                this.tally[index].pop();
                ret=0;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                   else { ret+=1; }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  else{ret+=1;}
                  }
                }
                this.table[index][1]=""+ret;
              },
                  
    placeTallyButtons : function(){
                       x=5*wt/6;
                       y1=(ht/this.table.length)/2-10;
                       html="";
                       for(i=0; i<this.table.length; i++){
                         html+="<button type=button class=line id=line_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x-20)+"px;\"> | </button>\n";
                         html+="<button type=button class=slash id=slash_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x)+"px;\"> / </button>\n";
                         html+="<button type=button class=undo id=undo_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x+20)+"px;\"> < </button>\n";
                         $("#tally").append(html);
                       }
                        },


    drawBasicBar : function(){
                  this.sp=(wt-this.mg)/this.table.length;
                  for(i = 0; i < this.table.length; i++){
                    context.save();
                    context.translate(this.mg+this.sp/2+i*this.sp, ht-this.mg/2);
                    if (this.table[i][0].length > 3){
                    context.rotate(-Math.PI/3);
                    }
                    context.textAlign="center";
                    context.fillText(this.table[i][0], 0, 0);
                    context.restore();
                  }
                  for(i = 0; i < this.table.length; i++){
                    he=(parseInt(this.table[i][1])/this.divs)*this.scale;
                    context.fillStyle=COLOR[i % COLOR.length];
                    context.fillRect(this.mg+i*this.sp+this.sp/4, ht-this.mg-he, this.sp/2, he);
                  }
                   },
    redraw : function(){
               this.chHTable();
               
               context.clearRect(0,0,wt, ht);
               if(this.type=="basicbar"){
                 this.drawBones();
                 this.drawBasicBar();
               }
               if(this.type=="tally"){
                 this.drawTallyMarks();
               }
             },
    editingBB : function(tr, wh){
                  if(tr > 0){
                    if(parseInt(this.table[wh][1]) > 0){
                      st=((parseInt(this.table[wh][1])-Math.floor(tr/this.scale)*this.divs));
                      if (st >= 0) {this.table[wh][1]=""+st;}
                    }
                  }
                  else{
                    st=((parseInt(this.table[wh][1])-Math.ceil(tr/this.scale)*this.divs));
                    if (st >= 0) {this.table[wh][1]=""+st;}
                  }
                  this.redraw();
                },
    chHTable : function(){
                 for(i=0; i<this.table.length; i++){
                   for(j=0; j < this.table[i].length; j++){
                     $("#"+table+" tr:eq("+i+")").find("input:eq("+j+")").attr("value", this.table[i][j]); 
                   }
                 }
               } 
                       
  };
  if($("#edit").attr("value")=="edit"){
    grph.setEditable(true);
  }
  grph.setType($("#type").attr("value"));
  if(grph.type=="tally"){
    grph.fromTable();
    if(grph.edit){
      grph.placeTallyButtons();
    }
    grph.preInitialTally();
    grph.drawTallyMarks();
  }
  else{
    if($("#editdivs").attr("value")=="true"){
      grph.setDivsEditable(true);
    }
    grph.setDivs($("#divs").attr("value"));
    grph.drawBones();
    grph.fromTable();
    grph.drawBasicBar();
  }



  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }
  $('.line').click(function(e){
    grph.addLine(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });
  $('.slash').click(function(e){
    grph.addSlash(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });
  $('.undo').click(function(e){
    grph.remLast(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });




  $('#datacanvas').mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    initdowny=mousey;
    mousedown=true;
  });
  $('#datacanvas').mouseup(function (e) { 
    mousedown=false;
  });
  $('#datacanvas').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    var offset = $('#datacanvas').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);
    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
    // global scope.
    if(mousedown){
      if(grph.edit){
        if(grph.type=="basicbar"){
          for(i =0; i<grph.table.length; i++){
            if(downx > grph.mg+grph.sp*i+grph.sp/4 && downx < grph.mg+grph.sp*i+3*grph.sp/4) {
              if(downy < ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale + 45 && downy > ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale -45){
                if(Math.abs(mousey-downy) >= grph.scale){
                  grph.editingBB(mousey-downy, i);
                  downy=mousey;
                }
              }
            }
          }
        }
      }
    }

  });


}
$(setUpDataGr)
