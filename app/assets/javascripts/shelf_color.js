function shelf_color(){
  var redarr=[];
  var greenarr=[];
  var bluearr=[];
  var i=0;
  var sumblue=0;
  var sumred=0;
  var sumgreen=0;
  var widpset=0;
  $('#bbor').children('.pset_pbar').each(function(){
        redarr[i]= $(this).children('.pset_bar').children('.bar-danger').width();
        widpset+=$(this).width();
        bluearr[i]= $(this).children('.pset_bar').children('.bar-info').width();
        sumblue=bluearr[i]+sumblue;
        sumred=redarr[i] + sumred;
        greenarr[i]= $(this).children('.pset_bar').children('.bar-success').width();
        sumgreen=greenarr[i] + sumgreen; 
        i++;

    });

var shelfwid=$("#bigshelf .shelf").width();
//$('#bigshelf .shelf ul').css("background-color","#ff0040");
//alert(shelfwid);
var green_per=(sumgreen/widpset)*100;
var green_val_shelf=(green_per/100)*shelfwid;
var blue_per = (sumblue/widpset)*100;
var blue_val_shelf= (blue_per/100)*shelfwid;
var red_per=  green_per + blue_per;

//$('#bigshelf .shelf ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue_per+"%,#ff0040 "+blue_per+"%)"); 
if(green_per!=0){
$('#bigshelf .shelf .shelf_ul').css("background","-webkit-gradient(linear,"+blue_per+"% 0%,"+red_per+"% 0%, from(#3498db), to(#e74c3c), color-stop(.005,#2ecc71),color-stop(.995,#2ecc71))");
}
else {
  $('#bigshelf .shelf .shelf_ul').css("background","-webkit-linear-gradient(left,#3498db "+blue_per+"%,#e74c3c "+blue_per+"%)"); 
}
$('#bigshelf .shelf .shelf_ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+blue_per+"%,#60b349 0%,#60b349 "+(red_per)+"%,#ff0040 0%)");

}
function shelf_color_in(blue, green, red){
  if(green != "0"){
$('#bigshelf .shelf_ul').css("background","-webkit-gradient(linear,"+parseInt(blue)+"% 0%,"+(parseInt(blue)+parseInt(green))+ "% 0%, from(#3498db), to(#e74c3c), color-stop(.005,#2ecc71),color-stop(.995,#2ecc71))")
}
else{
  if(blue!="0"){
    if(parseInt(blue)==100){
      $('#bigshelf .shelf_ul').css("background","#3498db"); 
    }
    else{
      $('#bigshelf .shelf_ul').css("background","-webkit-linear-gradient(left, #3498db "+parseInt(blue)+"%, #e74c3c "+parseInt(blue)+"%)"); 
    }
  }
  else{
    $('#bigshelf .shelf_ul').css("background","#e74c3c"); 
  }
}
$('#bigshelf .shelf_ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+parseInt(blue)+"%,#60b349 0%,#60b349 "+(parseInt(blue)+parseInt(green))+"%,#ff0040 0%)");
}