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
$('#bigshelf .shelf ul').css("background","-webkit-gradient(linear,"+blue_per+"% 0%,"+red_per+"% 0%, from(#0087bd), to(#ff0040), color-stop(.005,#60b349),color-stop(.995,#60b349))");
}
else {
  $('#bigshelf .shelf ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue_per+"%,#ff0040 "+blue_per+"%)"); 
}
$('#bigshelf .shelf ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+blue_per+"%,#60b349 0%,#60b349 "+(red_per)+"%,#ff0040 0%)");

}
function shelf_color_in(blue, green, red){
  if(green != "0"){
$('#bigshelf .shelf ul').css("background","-webkit-gradient(linear,"+blue+" 0%,"+(red)+ " 0%, from(#0087bd), to(#ff0040), color-stop(.005,#60b349),color-stop(.995,#60b349))")
}
else{
    $('#bigshelf .shelf ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue+",#ff0040 "+blue); 
}
$('#bigshelf .shelf ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+blue+",#60b349 0%,#60b349 "+red+",#ff0040 0%)");
}