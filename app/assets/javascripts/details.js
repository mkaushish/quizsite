function initConceptProgress(params) {
	$('li.stat').click(function() {
	var class_id = $(this).attr('data-classrm')
	  , ptype_id = $(this).attr('data-ptype');

	console.log("class: " + class_id + "\tptype_id: " + ptype_id)
	$.ajax(('/details_concept?classroom=' + class_id + '&problem_type=' + ptype_id),
		   { type : "POST", dataType : "script" });
	});

	// $('li.probs_done').each(function() {
	// 	setProbsDonePercent($(this), params.class_size);
	// });

	// $('li.percent').each(function() {

	// });

	// $('li.stu_attempted').each(function() {
	// 	setAttemptedPercent($(this), params.class_size);
	// });

	$('li.stat li').each(function() {
		setConceptStatWidth($(this));
	});
}

function setConceptStatWidth(stat) {		
	var $div = stat.children('div').first()
	  , w = $div.attr("data-percent");

	stat.addClass("stat-bar")
	$div.css("width", ""+w+"%");
}
