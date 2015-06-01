use utf8;

get '/order/' => sub {
	template 'order', {
		title => 'Оформить заказ',
		header => 'Оформить заказ'
	};
};

get '/cartajax' => sub {
	session cart => {} if (! defined session('cart'));
	my $cart = session('cart');
	return '[' . join(', ', keys(%{$cart})) . ']' if ( param('action') eq '' );
	if ( param('action') eq 'add' ) {
		$cart->{param('item')} = 1;
	} elsif ( param('action') eq 'remove' ) {
		delete $cart->{param('item')};
	}
	session cart => $cart;
	return '';
};

get '/cart/' => sub {
	template 'shopcart', {
		title => 'Корзина',
		header => 'Корзина'
	};
};