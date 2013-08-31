function walkthrough_pset(){
	$('#walkthrough').pagewalkthrough({
		steps: [
		{
			wrapper: '',
			margin: 0,
			popup:{
				content: '#intro_walk',
				type: 'modal',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}        
		},
		{
			wrapper: '#bigshelf',
			margin: '0',
			popup:
			{
				content: '#shelf_walk',
				type: 'tooltip',
				position: 'bottom',
				offsetHorizontal: 0,
				offsetVertical: -100,
				width: '500',
				draggable: true,
			}     
		},
		{
			wrapper: '.dotted-border',
			margin: '0',
			popup:
			{
				content: '#history_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.problem_list_box',
			margin: '0',
			popup:
			{
				content: '#bbor_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.label-info.correct_hist',
			margin: '0',
			popup:
			{
				content: '#correct_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.label-info.incorrect_hist',
			margin: '0',
			popup:
			{
				content: '#incorrect_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#open-walkthrough',
			margin: '0',
			popup:
			{
				content: '#open_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '',
			margin: '0',
			popup:
			{
				content: '#done_walk',
				type: 'modal',
				position: '',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}             
		},
		],
		name: 'Walkthrough',
		onLoad: true,
	});
$('.prev-step').live('click', function(e){
	$.pagewalkthrough('prev',e);
});

$('.next-step').live('click', function(e){
	$.pagewalkthrough('next',e);
});
$('#open-walkthrough').live('click', function(){
	var id = $(this).attr('id').split('-');

	if(id == 'parameters') return;

	$.pagewalkthrough('show', id[1]); 
});
}