function makeConceptsClickable() {
	$('li.stat').click(function() {
	var class_id = $(this).attr('data-classrm')
	  , ptype_id = $(this).attr('data-ptype');

	console.log("class: " + class_id + "\tptype_id: " + ptype_id)
	$.ajax(('/details_concept?classroom=' + class_id + '&problem_type=' + ptype_id),
		   { type : "POST", dataType : "script" });
	});
}
