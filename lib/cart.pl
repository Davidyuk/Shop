use Shop::DB;
use Shop::Common;
use strict;
#use warnings;
use utf8;

get '/cart/ajax' => sub {
	my $cart = session('cart');
	my $f;
	
	if (param('item')  =~ m/^\d+$/ ) {
		$cart->{param('item')} = 1 if !$f && ($f = param('action') eq 'add');
		delete $cart->{param('item')} if !$f && ($f = param('action') eq 'remove');
		$cart->{param('item')} = param('count') if !$f && ($f = param('count') =~ m/^\d+$/);
	}
	$cart = {} if !$f && ($f = param('action') eq 'clear');
	
	return '[' . join(', ', keys(%{$cart})) . ']' if ! $f;
	session cart => $cart;
	return '';
};

get '/cart/' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? ( [keys(%{session('cart')})] ) : ()
	}, undef);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'cart', {
		title => 'Корзина',
		header => 'Корзина',
		items => [$rs->all()],
		(defined session('user_id')) ? ( user => db()->resultset('User')->find(session('user_id')) ) : ()
	};
};

post '/cart/' => sub {
	if (param('address') eq '' || param('payment') eq '') {
		addMessage('Предпочитаемый способ оплаты не указан.', 'danger') if param('payment') eq '';
		addMessage('Адрес для доставки не указан.', 'danger') if param('address') eq '';
		return redirect '/cart/';
	}
	my $cart = session('cart');
	foreach (keys %{$cart}) {
		delete $cart->{$_} if ! $cart->{$_};
	}
	session cart => $cart;
	my $rs = db()->resultset('ItemJoined')->search({
		'me.id' => session('cart')	? ( [keys(%{session('cart')})] ) : ()
	}, undef);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my $order = db()->resultset('Order')->create({
		user_id => session('user_id'),
		items => join(';', map {$_->{id} . ':' . session('cart')->{$_->{id}} . ':' . $_->{price}} $rs->all()),
		status_id => 1, #default
		comment => '',
		createtime => 'now',
		payment => param('payment'),
		address => param('address')
	});
	session cart => {};
	addMessage('Заказ добавлен, номер заказа: ' . $order->id . '.', 'success');
	redirect session('user_id') ? '/cabinet/orders' : '/';
};

get '/cabinet/orders' => sub {	
	my $rs = db()->resultset('Order')->search({
		hidden => 'FALSE'
	}, {
		join => 'status',
		'+select' => 'status.name',
		'+as' => 'status_name',
		order_by => { -desc => 'createtime' },
		rows => 15, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @orders = $rs->all();
	foreach (@orders) {
		$_->{createtime} = timeToText($_->{createtime});
	}
	template 'orders', {
		title => 'Заказы',
		header => 'Заказы',
		items => [@orders],
		pages => $rs->pager()->last_page
	};
};

post '/cabinet/orders' => sub {
	my $order = db()->resultset('Order')->find(param('delete')) if param('delete') =~ m/^\d+$/;
	if (!(param('delete') =~ m/^\d+$/) || ! defined $order || $order->user_id != session('user_id') || $order->status_id == 2 || $order->hidden) {
		addMessage('Ошибка удаления заказа.', 'danger');
		return redirect '/cabinet/orders';
	}
	$order->hidden('TRUE');
	$order->update;
	addMessage('Заказ удалён успешно.', 'info');
	return redirect '/cabinet/orders';
};

get '/cabinet/order' => sub {
	return redirect '/cabinet/orders' if !(param('id') =~ m/^\d+$/);
	my $rs = db()->resultset('Order')->search({
		'me.id' => param('id')
	}, {
		join => 'status',
		'+select' => 'status.name',
		'+as' => 'status_name'
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my $order = $rs->single();
	if (! defined $order) {
		addMessage('Страница не найдена.', 'danger');
		status 404;
		return forward '/';
	}
	$order->{createtime} = timeToText($order->{createtime});
	my %items = ( map { (split(':', $_))[0] => { count => (split(':', $_))[1], price => (split(':', $_))[2] } }  split(';', $order->{items}) );
	my $price = 0;
	$price += $_->{price} * $_->{count} foreach (values %items);
	
	$rs = db()->resultset('ItemJoined')->search({
		id => [ map { (split(':', $_))[0] } split(';', $order->{items}) ]
	}, {
		rows => 10, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @items = $rs->all();
	foreach (@items) {
		$_->{price} = $items{$_->{id}}->{price};
		$_->{count} = $items{$_->{id}}->{count};
	}
	
	template 'order', {
		title => 'Заказ №' . $order->{id} . ', от ' . $order->{createtime},
		header => 'Заказ №' . $order->{id} . ', от ' . $order->{createtime},
		order => $order,
		items => [@items],
		price => $price,
		pages => $rs->pager()->last_page
	};
};