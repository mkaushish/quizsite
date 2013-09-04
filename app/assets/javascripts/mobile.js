function mob_comp(){
	if(!(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent))){
		not_comp=['Draw Triangle', 'Draw Quadrilateral', 'DefVertices', 
		'DefAdjacentSides', 'DefAdjacentVertices', 'AddNumberLine', 
		'SubNumberLine', 'CreateBar', 'CreateTally', 'BisectLine'];
		$('.list_box').each(function(){
			for (i=0; i < not_comp.length; i++){
				if($(this).children('p').text().indexOf(not_comp[i])!= -1){
					$(this).children('a').text('Not Compatible');
					$(this).children('a')[0].href='';
					$(this).children('a').css('background-color','#ccc');
					$(this).children('a').css('height','34px');
					$(this).children('a').css('margin-top','-15px');
				}
			}
		});
	}
}

