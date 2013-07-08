function badges_look(){
 	//bclr=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
 	bclr=["gold","silver","bronze"];
	for(i=0; i < $(".badges").length; i++){
		$(".badges").eq(i).css("top", 10*parseInt(i/6)-20);
		$(".badges").eq(i).css("left", 10*parseInt(i % 6));
		$(".badges").eq(i).css("background-color", bclr[i % 2]);
	}
	$(".badges").hover(function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 20*parseInt(i/6)-10-20);
			$(".badges").eq(i).css("left", 20*parseInt(i % 6)-10);
		}
	}, function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 10*parseInt(i/6)-20);
			$(".badges").eq(i).css("left", 10*parseInt(i % 6));
		}
	});
	for(i=0; i < $(".badgesbw").length; i++){
		$(".badgesbw").eq(i).css("top", 10*parseInt(i/6)-20);
		$(".badgesbw").eq(i).css("left", 10*parseInt(i % 6));
	}
	$(".badgesbw").hover(function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 20*parseInt(i/6)-10-20);
			$(".badgesbw").eq(i).css("left", 20*parseInt(i % 6)-10);
		}
	}, function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 10*parseInt(i/6)-20);
			$(".badgesbw").eq(i).css("left", 10*parseInt(i % 6));
		}
	});
}