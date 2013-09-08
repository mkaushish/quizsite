function webkit(){
	if(!$.browser.webkit){
		$('body').append('<div id=dimmer onclick=\'hide_webkit()\' style=\'display:block\'></div>');
		$('#dimmer').append('<div id=\'chrome_div\'></div>');
		$('#chrome_div').append('<a href=\'http://www.google.com/chrome\'><img class=\'chrome_icon\' src=\'/assets/chrome_icon.png\'/></a>');
		$('#chrome_div').append('<a href=\'http://google.com/chrome\'><p class=\'chrome_text\'>Click Here to Download Google Chrome for the Best SmarterGrades Experience</p></a>');
	}
}
function hide_webkit(){
	$('#dimmer').hide();
}