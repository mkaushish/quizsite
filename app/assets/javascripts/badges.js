function badges_look(){
 	//bclr=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
 	bclr=["gold","silver","bronze"];
	for(i=0; i < $(".badges").length; i++){
		$(".badges").eq(i).css("top", 10*parseInt(i/5)-20);
		$(".badges").eq(i).css("left", 10*parseInt(i % 5));
	}
	$("#get_badge").parent().hover(function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 20*parseInt(i/5)-10-20);
			$(".badges").eq(i).css("left", 20*parseInt(i % 5)-10);
		}
	}, function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 10*parseInt(i/5)-20);
			$(".badges").eq(i).css("left", 10*parseInt(i % 5));
		}
	});
	for(i=0; i < $(".badgesbw").length; i++){
		$(".badgesbw").eq(i).css("top", 10*parseInt(i/5)-20);
		$(".badgesbw").eq(i).css("left", 10*parseInt(i % 5));
	}
	$("#get_badge2").parent().hover(function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 20*parseInt(i/5)-10-20);
			$(".badgesbw").eq(i).css("left", 20*parseInt(i % 5)-10);
		}
	}, function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 10*parseInt(i/5)-20);
			$(".badgesbw").eq(i).css("left", 10*parseInt(i % 5));
		}
	});
}