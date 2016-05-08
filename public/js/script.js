function networkError() {
	alert('Произошла ошибка, требуется обновить страницу.');
}	

jQuery(document).ready(function($) {
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
	
	function checkPasswords() {
		var password = this.value;
		var valid = true;
		var form = $(this).parents('form');
		form.find('.password').each(function(id, dom){
			valid &= dom.value == password;
			dom.setCustomValidity(valid ? '' : 'Пароли не совпадают');
		});
	}
	$('form .password').focus(checkPasswords);
	$('form .password').change(checkPasswords);
	
	if ($.kladr) {
		$('#address').kladr({
			token: '5563e1530a69de66388b45f5',
			oneString: true
		});
	}
	
	var cart_count = 0;
	function setCartCount(count) {
		cart_count = count;
		$('#badge-cart').text(cart_count ? cart_count : '');
	}
	var cart = {};
	$.ajaxSetup({cache: false});
	$.getJSON('/cart', function(data){
		for (var i = 0; i < data.length; i++)
			cart[data[i]] = true;
		cart_count = data.length;
	}).error(networkError);
	
	$('.btn-cart').click(function() {
		cart[$(this).data('id')] = !cart[$(this).data('id')];
		$.get('/cart', {
			item: $(this).data('id'),
			action: cart[$(this).data('id')] ? 'add' : 'remove',
		}).error(networkError);
		$($(this).children()[0]).text(cart[$(this).data('id')] ? 'В корзине' : 'В корзину');
		$(this).toggleClass('btn-default').toggleClass('btn-success');
		setCartCount(cart_count + (cart[$(this).data('id')] ? 1 : -1));
	});
	
	$('.form-order-delete').submit(function() {
		return confirm('Вы уверены, что хотите удалить этот заказ?');
	});
});