use Shop::DB qw(db);
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
	return '[' . join(', ', keys(%{$cart})) . ']' if ( param('action') eq '' && param('count') eq '' );
	if ( param('action') eq 'add' ) {
		$cart->{param('item')} = 1;
	} elsif ( param('action') eq 'remove' ) {
		delete $cart->{param('item')};
	} elsif ( param('count') ne '' ) {
		$cart->{param('item')} = param('count') if param('count') >= 0;
	}
	session cart => $cart;
	return '';
};

get '/cart/' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? ( [keys(%{session('cart')})] ) : ()
	}, {
		rows => 15, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	template 'cart', {
		title => 'Корзина',
		header => 'Корзина',
		items => [$rs->all()],
		pages => $rs->pager()->last_page
	};
};