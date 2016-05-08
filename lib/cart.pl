use Dancer::Plugin::Ajax;
use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;
use JSON qw//;

hook before => sub {
	session cart => {} if ! defined session('cart');
};

ajax '/cart' => sub {
	my ($cart, $f) = (session('cart'), false);	
	if (isParamUInt('item')) {
		$cart->{param('item')} = 1 if !$f && ($f = isParamEq('action', 'add'));
		delete $cart->{param('item')} if !$f && ($f = isParamEq('action', 'remove'));
		$cart->{param('item')} = param('count') if !$f && ($f = isParamUInt('count'));
	}
	$cart = {} if !$f && ($f = isParamEq('action', 'clear'));
	
	unless ($f) {
		content_type 'application/json';
		return JSON::to_json [ keys(%{$cart}) ];
	}
	session cart => $cart;
	return '';
};

push $Shop::menu, { name => 'Корзина', href => '/cart' };

any ['get', 'post'] => '/cart' => sub {
	my ($valid, $user) = (request->is_post, session('uid') ? db()->resultset('User')->find(session('uid')) : undef);
	my ($payment, $address);
	if ($valid) {
		($payment, $address) = (param('payment'), param('address'));
		if ($user) {
			$payment = $user->payment unless isParamNEmp('payment');
			$address = $user->address unless isParamNEmp('address');;
		}
		addMessage('Способ оплаты не указан.', 'danger') unless $payment || ($valid = false);
		addMessage('Адрес для доставки не указан.', 'danger') unless $address || ($valid = false);
	}
	
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? [keys(%{session('cart')})] : []
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return template 'cart', {
		items => [$rs->all()],
		user => $user
	} unless $valid;
	
	my $cart = session('cart');
	foreach (keys %{$cart}) { #удалить товары из корзины количество которых == 0
		delete $cart->{$_} unless $cart->{$_};
	}
	
	$rs = db()->resultset('ItemJoined')->search({
		'me.id' => [keys(%{$cart})]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my $order = db()->resultset('Order')->create({
		user_id => session('uid'),
		items => join(';', map {$_->{id} . ':' . $cart->{$_->{id}} . ':' . $_->{price}} $rs->all()), #id:count:price;id:count:price;id:count:price
		status_id => 1, #default - Ожидает оплаты
		comment => '',
		createtime => 'now',
		payment => $payment,
		address => $address
	});
	session cart => {};
	addMessage('Заказ добавлен. Номер заказа: ' . $order->id . '.', 'success');
	redirect session('uid') ? '/cabinet/orders' : '/';
};