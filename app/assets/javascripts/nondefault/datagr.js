
function setUpDataGr() {
  var canvas = $('#datacanvas')[0];
  if(canvas == undefined) { return undefined; }
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var mousedown=false;
  var ht = canvas.height;
  var wt = canvas.width; 

  var grph={
    mg : 50,
    type : "basicbar",
    scale : 30,
    edit : false,
    divs : 10,
    dir : 'x',
    head : "",
    start : 0,
    table : new Array(),
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
                  drawLine(this.mg, ht-this.mg, this.mg, 0);
                  drawLine(wt, ht-this.mg, this.mg, ht-this.mg);
                  for (i = 0; i <= ((ht-this.mg) / this.scale) ; i++) {
                    drawLine(this.mg, ht-this.mg-i*this.scale,wt, ht-this.mg-i*this.scale);
                    context.textAlign="right";
                    context.fillText(this.divs*i, this.mg-1, ht-this.mg-i*this.scale+8); 
                  }
                },
    fromTable : function(){
                  $("#table tr").each(function() {
                    var arrayOfThisRow = [];
                    var tableData = $(this).find('td');
                    if (tableData.length > 0) {
                      tableData.each(function() { arrayOfThisRow.push($(this).text()); });
                      grph.table.push(arrayOfThisRow);
                    }
                  });
                },
    drawBasicBar : function(){
                  this.sp=(wt-this.mg)/this.table.length;
                  for(i = 0; i < this.table.length; i++){
                    context.save();
                    context.translate(this.mg+this.sp/2+i*this.sp, ht-this.mg/2);
                    context.rotate(-Math.PI/3);
                    context.textAlign="center";
                    context.fillText(this.table[i][0], 0, 0);
                    context.restore();
                  }
                  for(i = 0; i < this.table.length; i++){
                    he=(parseInt(this.table[i][1])/this.divs)*this.scale;
                    context.fillRect(this.mg+i*this.sp+this.sp/4, ht-this.mg-he, this.sp/2, he);

                  }
                   },
    redraw : function(){
               context.clearRect(0,0,wt, ht);
               this.drawBones();
               if(this.type=="basicbar"){
                 this.drawBasicBar();
               }
             },
    editingBB : function(tr, wh){
                  if(tr > 0){
                    if(parseInt(this.table[wh][1]) > 0){
                      this.table[wh][1]=""+((parseInt(this.table[wh][1])-Math.floor(tr/this.scale)*this.divs));
                    }
                  }
                  else{
                    this.table[wh][1]=""+((parseInt(this.table[wh][1])-Math.ceil(tr/this.scale)*this.divs));
                  }
                  this.chHTable();
                  this.redraw();
                },
    chHTable : function(){
                 html=""
                 for(i=0; i<this.table.length; i++){
                   html+="<tr>";
                   for(j=0; j < this.table[i].length; j++){
                     html+="<td>"+this.table[i][j]+"</td>";
                   }
                   html+="</tr>"
                 }
                 $("#table").html(html);
               } 
                       
  };
  if($("#edit").attr("value")=="edit"){
    grph.setEditable(true);
  }
  if($("#editdivs").attr("value")=="true"){
    grph.setDivsEditable(true);
  }
  grph.setDivs($("#divs").attr("value"));

  grph.drawBones();
  grph.fromTable();
  grph.drawBasicBar();




  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }
  $('#datacanvas').mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    mousedown=true;
  });
  $('#datacanvas').mouseup(function (e) { 
    if(mousedown){
      if(grph.edit){
        if(grph.type=="basicbar"){
          for(i =0; i<grph.table.length; i++){
            if(downx > grph.mg+grph.sp*i+grph.sp/4 && downx < grph.mg+grph.sp*i+3*grph.sp/4) {
              if(downy < ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale + 15 && downy > ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale -5){
              grph.editingBB(mousey-downy, i);
              downy=mousey;
            }
            }
          }
        }
      }
    }
    mousedown=false;
  });
  $('#datacanvas').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    var offset = $('#datacanvas').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);
    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;

  });


}
$(setUpDataGr)
