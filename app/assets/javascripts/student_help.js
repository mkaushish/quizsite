$(document).ready(function(){

	$('#walkthrough').pagewalkthrough({

		steps:
        [
               {
                   wrapper: '#site_logo',
                   margin: 0,
                   popup:
                   {
                       content: '#type-modal',
                       type: 'modal',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }        
               },
               /*{
                   wrapper: '',
                   margin: '0',
                   popup:
                   {
                       content: '#type-tooltip',
                       type: 'tooltip',
                       position: 'bottom',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '500'
                   }     
               },
               {
                   wrapper: '#email-us',
                   margin: '0',
                   popup:
                   {
                       content: '#type-tooltip-top',
                       type: 'tooltip',
                       position: 'top',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }                
               },
               {
                   wrapper: '#enquiry-type',
                   margin: '0',
                   popup:
                   {
                       content: '#type-tooltip-right',
                       type: 'tooltip',
                       position: 'right',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }                
               },
               {
                   wrapper: '#page-desc',
                   margin: '0',
                   popup:
                   {
                       content: '#type-tooltip-bottom',
                       type: 'tooltip',
                       position: 'bottom',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }                
               },
               {
                   wrapper: '.content-right',
                   margin: '0',
                   popup:
                   {
                       content: '#type-tooltip-left',
                       type: 'tooltip',
                       position: 'left',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }                
               },
               {
                   wrapper: '#page-desc',
                   margin: '0',
                   popup:
                   {
                       content: '#type-no-highlight',
                       type: 'nohighlight',
                       position: 'bottom',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }                
               },
               {
                   wrapper: '#enquiry-name',
                   margin: '0',
                   popup:
                   {
                       content: '#tooltip-draggable',
                       type: 'tooltip',
                       position: 'left',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400',
                       draggable: true
                   }                
               },
               {
                   wrapper: '#enquiry-phone',
                   margin: '0',
                   popup:
                   {
                       content: '#nohighlight-draggable',
                       type: 'nohighlight',
                       position: 'top',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400',
                       draggable: true
                   }                
               },
               {
                   wrapper: '#enquiry-email',
                   margin: '0',
                   popup:
                   {
                       content: '#content-rotation',
                       type: 'nohighlight',
                       position: 'bottom',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400',
                       contentRotation: 10
                   }                
               },
               {
                   wrapper: '#enquiry-phone',
                   margin: '0',
                   popup:
                   {
                       content: '#highlight-accessable',
                       type: 'tooltip',
                       position: 'left',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   },
                   accessable: true                
               },
               {
                   wrapper: '#australia',
                   margin: '0',
                   popup:
                   {
                       content: '#auto-scroll',
                       type: 'nohighlight',
                       position: 'top',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   },
                   autoScroll: false              
               },
               {
                   wrapper: '.search-box',
                   margin: '0',
                   popup:
                   {
                       content: '#stay-focus',
                       type: 'tooltip',
                       position: 'bottom',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   },
                   accessable: true,
                   stayFocus: true              
               },
               {
                   wrapper: '',
                   margin: '0',
                   popup:
                   {
                       content: '#done-walkthrough',
                       type: 'modal',
                       position: '',
                       offsetHorizontal: 0,
                       offsetVertical: 0,
                       width: '400'
                   }             
               },*/

        ],
        name: 'Walkthrough',
        onLoad: true, //load the walkthrough at first time page loaded
onBeforeShow: null, //callback before page walkthrough loaded
onAfterShow: null, // callback after page walkthrough loaded
onRestart: null, //callback for onRestart walkthrough
onClose: null, //callback page walkthrough closed
onCookieLoad: null //when walkthrough closed, it will set cookie and tells the walkthrough to not load automaticly
    });
$('.main-menu ul li a').each(function(){
      $('.main-menu ul li').find('a.active').removeClass('active');
      $(this).live('click', function(){
          $(this).addClass('active');
          var id = $(this).attr('id').split('-');

          if(id == 'parameters') return;

          $.pagewalkthrough('show', id[1]); 
      });
  });
});