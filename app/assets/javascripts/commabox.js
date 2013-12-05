function commaBox(name){
  $("#"+name).click(function(e){
    if($("#"+name).attr("value")=="0"){
      $("#"+name).attr("value", "1");
      $("#"+name).addClass("commachecked");
    }
    else{
      $("#"+name).attr("value", "0");
      $("#"+name).removeClass("commachecked");
    }
  });
}