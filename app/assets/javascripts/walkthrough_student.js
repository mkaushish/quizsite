function walkthrough_student(){
	not_mobile= !(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));
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
			wrapper: '#account',
			margin: '0',
			popup:
			{
				content: '#account_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#points',
			margin: '0',
			popup:
			{
				content: '#points_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#notifications',
			margin: '0',
			popup:
			{
				content: '#notif_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_1',
			margin: '0',
			popup:
			{
				content: '#shape_1_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_2',
			margin: '0',
			popup:
			{
				content: '#shape_2_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_3',
			margin: '0',
			popup:
			{
				content: '#shape_3_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_4',
			margin: '0',
			popup:
			{
				content: '#shape_4_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_5',
			margin: '0',
			popup:
			{
				content: '#shape_5_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
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
			wrapper: '.pset_list_box',
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
			wrapper: '.progress',
			margin: '0',
			popup:
			{
				content: '#pbar_walk',
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
		onLoad: not_mobile,
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
$('.close-step').live('click', function(e){
      $.pagewalkthrough('close');
  });
}