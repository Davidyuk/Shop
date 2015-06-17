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
	
	$('#address').kladr({
		token: '5563e1530a69de66388b45f5',
		oneString: true
	});
	
	function networkError() {
		alert('Ошибка при соединении с сервером, требуется обновить страницу.');
	}	
	var cart_count = 0;
	function setCartCount(count) {
		cart_count = count;
		$('#badge-cart').text(cart_count ? cart_count : '');
	}
	var cart = {};
	$.ajaxSetup({cache: false});
	$.getJSON('/cart/ajax', function(data){
		for (var i = 0; i < data.length; i++)
			cart[data[i]] = true;
		cart_count = data.length;
	}).error(networkError);
	
	$('.btn-cart').click(function() {
		cart[$(this).data('id')] = !cart[$(this).data('id')];
		$.get('/cart/ajax', {
			item: $(this).data('id'),
			action: cart[$(this).data('id')] ? 'add' : 'remove',
		}).error(networkError);
		$($(this).children()[0]).text(cart[$(this).data('id')] ? 'В корзине' : 'В корзину');
		$(this).toggleClass('btn-default').toggleClass('btn-success');
		setCartCount(cart_count + (cart[$(this).data('id')] ? 1 : -1));
	});
	
	function updateFinalPrice() {
		var prices = $('#cart .price');
		var inputs = $('#cart input');
		var sum = 0;
		for (var i = 0; i < prices.length; i++)
			sum += $(prices[i]).text() * $(inputs[i]).val();
		$('#final-price').text(sum);
		return prices.length;
	}
	
	$('#cart form').submit(function() {
		if ($('#final-price').text() == 0) {
			alert('Невозможно сделать заказ: общая стоимость равна нулю.');
			return false;
		}
	});
	
	$('#cart .btn-cart-clear').click(function() {
		if (confirm('Вы уверены, что хотите очистить корзину?')) {
			setCartCount(0);
			$('#cart').replaceWith($('<p/>', {text: 'Корзина не содержит элементов.'}));
			$.get('/cart/ajax', {
				action: 'clear'
			}).error(networkError);
		}
	});
	
	$('#cart .btn-cart-delete').click(function() {
		if (confirm('Вы уверены, что хотите удалить этот элемент из корзины?')) {
			$('#item-' + $(this).data('item')).remove();
			setCartCount(cart_count - 1);
			if (!updateFinalPrice())
				$('#cart').replaceWith($('<p/>', {text: 'Корзина не содержит элементов.'}));
			$.get('/cart/ajax', {
				item: $(this).data('item'),
				action: 'remove'
			}).error(networkError);
		}
	});
	
	$('#cart .btn-cart-add').click(function() {
		var item = $('#item-' + $(this).data('item'));
		var input = item.find('input');
		input.val(input.val() * 1 + 1);
		item.find('.btn-cart-sub').attr("disabled", false);
		updateFinalPrice();
		$.get('/cart/ajax', {
			item: $(this).data('item'),
			count: input.val()
		}).error(networkError);
	});
	
	$('#cart .btn-cart-sub').click(function() {
		var item = $('#item-' + $(this).data('item'));
		var input = item.find('input');
		input.val(input.val() * 1 - 1);
		if (input.val() == 0) $(this).attr("disabled", true);
		updateFinalPrice();
		$.get('/cart/ajax', {
			item: $(this).data('item'),
			count: input.val()
		}).error(networkError);
	});
	
	$('#cart table input').keyup(function() {
		this.value = this.value.replace(/[^0-9\.]/g,'') * 1;
		$('#item-' + $(this).data('item') + ' .btn-cart-sub').attr("disabled", !(this.value*1));
		updateFinalPrice();
		$.get('/cart/ajax', {
			item: $(this).data('item'),
			count: this.value
		}).error(networkError);
	});
	
	$('.form-order-delete').submit(function() {
		return confirm('Вы уверены, что хотите удалить этот заказ?');
	});
});