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
	
	function networkError() {
		alert('Ошибка при соединении с сервером, требуется обновить страницу.');
	}	
	var cart_count = 0;
	function setCartCount(count) {
		cart_count = count;
		if (cart_count) $('.badge-cart').text(cart_count)
		else $('.badge-cart').text('');
	}
	var cart = {};
	$.ajaxSetup({cache: false});
	$.getJSON('/cartajax', function(data){
		for (var i = 0; i < data.length; i++)
			cart[data[i]] = true;
		cart_count = data.length;
	}).error(networkError);
	
	$('.btn-cart').click(function() {
		cart[$(this).data('id')] = !cart[$(this).data('id')];
		$.get('/cartajax', {
			item: $(this).data('id'),
			action: cart[$(this).data('id')] ? 'add' : 'remove',
		}).error(networkError);
		$($(this).children()[0]).text(cart[$(this).data('id')] ? 'В корзине' : 'В корзину');
		$(this).toggleClass('btn-default');
		$(this).toggleClass('btn-success');
		setCartCount(cart_count + (cart[$(this).data('id')] ? 1 : -1));
	});
});