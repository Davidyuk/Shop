jQuery(document).ready(function($) {
	//$(".catalog .item td:nth-child(1)").click(function() {
	//	window.document.location = $(this).parent().data("url");
	//});
	
	$('.category_menu .plate').bind('mousewheel DOMMouseScroll', function(e) {
		switch (e.type) {
			case 'mousewheel': scrollTo = (e.originalEvent.wheelDelta * -1); break;
			case 'DOMMouseScroll': scrollTo = 40 * e.originalEvent.detail / 2; break;
			default: scrollTo = null;
		}
		if (scrollTo) {
			e.preventDefault();
			$(this).scrollTop(scrollTo + $(this).scrollTop());
		}
	});
});