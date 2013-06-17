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
$('#bigshelf .shelf ul').css("background","-webkit-gradient(linear,"+blue_per+"% 0%,"+red_per+"% 0%, from(#0087bd), to(#ff0040), color-stop(.01,#60b349),color-stop(.99,#60b349))")
}
else {
  $('#bigshelf .shelf ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue_per+"%,#ff0040 "+blue_per+"%)"); 


}


}