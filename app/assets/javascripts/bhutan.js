function bhutan(){

  function ts(desc, mi, lo){
    this.desc=desc;
    this.mi=mi;
    this.lo=lo;
  }

  function lo(type, desc, dgoal){
    this.desc=desc;
    this.type=type;
    this.ts=[];
    this.dgoal=dgoal;
  }

  numRowLo=0;
  numRowTs=0;
  specs=["social", "physical", "emotional", "cerebral", "spiritual"];
  cols={"social":"red", "physical":"green", "emotional":"yellow", "cerebral":"blue", "spiritual":"orange"}
  var over=["Collaboration", "Communication", "Responsible Citizenship", "Self Reflection", "Creativity", "Critical Thinking"];
  kw={
    "Team Work":[[0], [0,1]], 
    "Managing People":[[0], []], 
    "Managing Conflict":[[0], []], 
    "Empathy":[[0, 2], []], 
    "Civic Conciousness":[[], []], 
    "Respect":[[], []], 
    "Ethics":[[], []], 
    "Understanding Cultures":[[], []],
    "Open Mindedness":[[], []],
    "Confidence":[[], []],
    "Adaptability":[[], []],
    "Self Awareness":[[], []],
    "Self Discipline":[[], []],
    "Accepting Consequences of Behavior":[[], []],
    "Independence":[[], []],
    "Decision Making":[[], []],
    "Problem Solving":[[], []],
    "Respect for Nature":[[], []],
  };
  var keywords=[];
  for (ty in kw){
    keywords.push(ty);
  }
  var intelligences=["Logical", "Linguistic", "Visual/Spatial", "Musical", "Kinesthetic", "Interpersonal", "Intrapersonal", "Naturalistic"];


  function addRowLo(){

    html="<tr id=loRow_"+(numRowLo+1)+">";

    html+="<td>"+(numRowLo+1)+"</td>";

    html+="<td>";

    html+="<select class=loArea>";

    html+="<option value=knowledge>Knowledge</option>";

    html+="<option value=skills>Skills</option>";

    html+="<option value=attitudes>Attitudes</option>";

    html+="</select>";

    html+="<textarea class=lo rows=3, cols=15></textarea>";

    html+="</td>";

    html+="<td>";

    for(i=0; i < keywords.length; i++){
      html+="<input type=checkbox id=dev_"+(numRowLo)+"_"+i+">"+keywords[i];
    }
    html+="</td>";

    
    html+="</tr>";

    $("#lo").append(html);
    numRowLo+=1;

    for(p=0; p < numRowTs; p++){
      $("#lob_"+p).append("<div id=lo_"+p+"_"+(numRowLo-1)+"><input type=checkbox>"+numRowLo+"</input></div>");
    }

  }

  addRowLo();





  $("#pluslo").click(function(e){

    addRowLo(); 

  });

  $("#minuslo").click(function(e){

    $("#loRow_"+numRowLo).remove();

    $("#lo_"+(numRowLo-1)).remove();

    numRowLo-=1;

  });

  function addRowTs(){
    html="<tr id=tsRow_"+(numRowTs+1)+">";

    html+="<td><textarea class=kn rows=3, cols=15></textarea></td>";

    html+="<td>";

    for(i=0; i < intelligences.length; i++){

    html+="<input type=checkbox id=mi_"+numRowTs+"_"+i+">"+intelligences[i]+"</input>";

    }


    html+="</td>";

    html+="<td class=lob id=lob_"+numRowTs+">";

    for (i=0; i<numRowLo; i++){

      html+="<div id=lo_"+numRowTs+"_"+i+">";

      html+="<input type=checkbox>"+(i+1)+"</input></div>";

    }

    html+="</td>";

    html+="</tr>";

    $("#ts").append(html);
    numRowTs+=1;
  }
  addRowTs();

  $("#plusts").click(function(e){

    addRowTs();
  });

  $("#minusts").click(function(e){

    $("#tsRow_"+numRowTs).remove();

    $("#ts_"+(numRowTs-1)).remove();

    numRowTs-=1;

  });
  $("#save").click(function(e){
    los=[];
    tss=[];
    for(i=0; i < numRowLo; i++){
      ty=$("#loRow_"+(i+1)).find("td").eq(1).find(".loArea").attr("value");
      de=$("#loRow_"+(i+1)).find("td").eq(1).find(".lo").attr("value");
      dg=[];
      for(j=0; j < keywords.length; j++){
        if($("#dev_"+i+"_"+j).attr("checked")=="checked"){
          dg.push(keywords[j]);
        }
      }
      los[i]=new lo(ty, de, dg);
    }
    for(i=0; i < numRowTs; i++){
      de=$("#tsRow_"+(i+1)).find("td").eq(0).find(".kn").attr("value");
      inte=[];
      lobs=[];
      tss[i]=new ts(de, inte, lobs);
      for(j=0; j < intelligences.length; j++){
        if($("#mi_"+i+"_"+j).attr("checked")=="checked"){
          inte.push(intelligences[j]);
        }
      }
      tss[i].mi=inte;
      for(j=0; j < los.length; j++){
        if($("#lo_"+i+"_"+j).find("input").attr("checked")=="checked"){
          lobs.push(los[j]);
          los[j].ts.push(tss[i]);
        }
      }
      tss[i].lo=lobs;
    }

  });

  $("#view").click(function(e){
    html="<div id=vi>";
    html+="<table id=lea border=1>";
    html+="<tr>";
    html+="<td>Knowledge</td>";
    html+="<td>Skills</td>";
    html+="<td>Attitudes</td>";
    html+="<td>Development Goals</td>";
    html+="<td>SPECS</td>";
    html+="<td>";
    html+="<table>";
    html+="<tr>";
    html+="<td>Teaching Strategies</td>";
    html+="<td>Multiple Intelligences</td>";
    html+="</tr>";
    html+="</table>";
    html+="</td>";
    html+="</tr>";
    for(i=0; i< los.length; i++){
      html+="<tr>";
      if(los[i].type=="knowledge"){
        html+="<td>"+los[i].desc+"</td>";
        html+="<td>  </td>";
        html+="<td>  </td>";
      }
      if(los[i].type=="skills"){
        html+="<td>  </td>";
        html+="<td>"+los[i].desc+"</td>";
        html+="<td>  </td>";
      }
      if(los[i].type=="attitudes"){
        html+="<td>  </td>";
        html+="<td>  </td>";
        html+="<td>"+los[i].desc+"</td>";
      }
      html+="<td style=\"width:250px;\">"+los[i].dgoal.join(", ")+"</td>";
      sparr=[];
      html+="<td><table border=1>";
      for(j=0; j < los[i].dgoal.length; j++){
        sp=kw[los[i].dgoal[j]][0];
        for(k=0; k < sp.length; k++){
          if(sparr.indexOf(specs[sp[k]])==-1){
          alert(specs[sp[k]]);
            sparr.push(specs[sp[k]]);
            html+="<tr><td style=\"background-color:"+cols[specs[sp[k]]]+"\">"+specs[sp[k]]+"</td></tr>";
          }
        }
      }
      html+="</table></td>";

      tts=los[i].ts;
      html+="<td>"; 
      html+="<table>";
      for(j=0; j < tts.length; j++){
        html+="<tr>";
        html+="<td>"+tts[j].desc+"</td>";
        html+="<td>";
        html+="<table>";
        for(k=0; k<tts[j].mi.length; k++){
          html+="<tr><td>"+tts[j].mi[k]+"</td></tr>";
        }
        html+="</table>";
        html+="</td>";
        html+="</tr>";
      }
      html+="</table>";
      html+="</td>"; 
      html+="</tr>";
      
    }
    html+="</table>";
    html+="</div>";
    $("#viewing").append(html);
    $("#editing").hide();
    $("#viewing").show();
  });
  $("#edit").click(function(e){
    $("#editing").show();
    $("#viewing").hide();
    $("#vi").remove();
  });

}
