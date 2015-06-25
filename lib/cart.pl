use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

get '/cart/ajax' => sub {
	my ($cart, $f) = (session('cart'), false);	
	if (isParamUInt('item')) {
		$cart->{param('item')} = 1 if !$f && ($f = isParamEq('action', 'add'));
		delete $cart->{param('item')} if !$f && ($f = isParamEq('action', 'remove'));
		$cart->{param('item')} = param('count') if !$f && ($f = isParamUInt('count'));
	}
	$cart = {} if !$f && ($f = isParamEq('action', 'clear'));
	
	return '[' . join(', ', keys(%{$cart})) . ']' if ! $f;
	session cart => $cart;
	return '';
};

push $Shop::menu, { name => 'Корзина', href => '/cart' };

get '/cart' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? [keys(%{session('cart')})] : []
	}, undef);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'cart', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js', 'cart.js' ],
		title => 'Корзина',
		items => [$rs->all()],
		session('user_id') ? ( user => db()->resultset('User')->find(session('user_id')) ) : ()
	};
};

post '/cart' => sub {
	my ($valid, $user) = (true, session('user_id') ? db()->resultset('User')->find(session('user_id')) : undef);
	my ($payment, $address) = (param('payment'), param('address'));
	if ($user) {
		$payment = $user->payment unless isParamNEmp('payment');
		$address = $user->address unless isParamNEmp('address');;
	}
	addMessage('Способ оплаты не указан.', 'danger') unless $payment || ($valid = false);
	addMessage('Адрес для доставки не указан.', 'danger') unless $address || ($valid = false);
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? [keys(%{session('cart')})] : []
	}, undef);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return template 'cart', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js', 'cart.js' ],
		title => 'Корзина',
		items => [$rs->all()],
		$user ? ( user => $user ) : ()
	} unless $valid;
	my $cart = session('cart');
	foreach (keys %{$cart}) {
		delete $cart->{$_} unless $cart->{$_};
	}
	printd($cart);
	$rs = db()->resultset('ItemJoined')->search({
		'me.id' => [keys(%{$cart})]
	}, undef);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my $order = db()->resultset('Order')->create({
		user_id => session('user_id'),
		items => join(';', map {$_->{id} . ':' . $cart->{$_->{id}} . ':' . $_->{price}} $rs->all()),
		status_id => 1, #default - Ожидает оплаты
		comment => '',
		createtime => 'now',
		payment => $payment,
		address => $address
	});
	session cart => {};
	addMessage('Заказ добавлен, номер заказа: ' . $order->id . '.', 'success');
	redirect session('user_id') ? '/cabinet/orders' : '/';
};