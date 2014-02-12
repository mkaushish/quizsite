
function addingForm(name, n1, n2, sign){
  lt=1+Math.max(n1.length, n2.length);
  var ht="<table id=laddtable_"+name+" border=0>\n";
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
      ht+="<td><input type=text class="+name+"_linps id="+name+"_lin"+i+" maxlength=1 style=\"width:15px; height:20px\"></td>\n";
    }
  ht+="</tr>\n"
    ht+="</table>";
  $('#ladding_'+name).append(ht);
  $('#laddtable_'+name).attr("style", "background-color:transparent; font:10pt Courier;");
  $("#"+name+"_lin"+(lt-1)).select();
  tot=[];
  $("."+name+"_linps").keypress(function(e){
    String.fromCharCode(e.keyCode)
    if(e.keyCode > 47 && e.keyCode < 58) {
      tot[$(this).attr("id")[$(this).attr("id").length-1]]=String.fromCharCode(e.keyCode);
      $(this).attr("value", String.fromCharCode(e.keyCode));
      $("#"+name).attr("value", tot.join(""));
    }
  });
  for (var j=1; j<lt; j++)
  {
    $("#"+name+"_lin"+j).keypress({j:j}, function(e){
        $("#"+name+"_lin"+(e.data.j-1)).select();
    });
  }

}
