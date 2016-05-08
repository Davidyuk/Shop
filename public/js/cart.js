jQuery(document).ready(function($) {
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
			$.get('/cart', {
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
			$.get('/cart', {
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
		$.get('/cart', {
			item: $(this).data('item'),
			count: input.val()
		}).error(networkError);
	});
	
	$('#cart .btn-cart-sub').click(//function() { h(this, function (x) { return x * 1 - 1 }) }
		var item = $('#item-' + $(this).data('item'));
		var input = item.find('input');
		input.val(input.val() * 1 - 1);
		if (input.val() == 0) $(this).attr("disabled", true);
		updateFinalPrice();
		$.get('/cart', {
			item: $(this).data('item'),
			count: input.val()
		}).error(networkError);
	});
	
	var h = function (obj, f) {
		var item = $('#item-' + $(obj).data('item'));
		var input = item.find('input');
		input.val(f(input.val());
		if (input.val() == 0) $(this).attr("disabled", !(input.val() * 1));
		updateFinalPrice();
		$.get('/cart', {
			item: $(this).data('item'),
			count: input.val()
		}).error(networkError);
	};
	
	$('#cart table input').keyup(function() {
		this.value = this.value.replace(/[^0-9\.]/g,'') * 1;
		$('#item-' + $(this).data('item') + ' .btn-cart-sub').attr("disabled", !(this.value*1));
		updateFinalPrice();
		$.get('/cart', {
			item: $(this).data('item'),
			count: this.value
		}).error(networkError);
	});
});