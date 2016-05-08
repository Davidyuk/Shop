package Shop::Orders;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

prefix '/cabinet/orders';

hook before_template => sub {
	addUserMenuItem({name => 'Состояние заказов', href => '/cabinet/orders', icon => 'glyphicon-list'});
};

get '' => sub {	
	my $rs = db()->resultset('Order')->search({
		hidden => 'FALSE',
		user_id => session('uid')
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
	template 'cabinet/orders/orders', {
		orders => [@orders],
		pages => $rs->pager()->last_page
	};
};

post '' => sub {
	my $f = isParamUInt('delete');
	my $order = db()->resultset('Order')->find(param('delete')) if $f;
	$f &&= $order && $order->user_id == session('uid') && $order->status_id != 2 && ! $order->hidden;
	unless ($f) {
		addMessage('Ошибка удаления заказа.', 'danger');
		return redirect '/cabinet/orders';
	}
	$order->hidden('TRUE');
	$order->update;
	addMessage('Заказ удалён успешно.', 'info');
	redirect '/cabinet/orders';
};

get '/:id' => sub {
	my $f = isParamUInt('id');
	my $order = undef;
	if ($f) {
		my $rs = db()->resultset('Order')->search({
			'me.id' => param('id')
		}, {
			join => 'status',
			'+select' => 'status.name',
			'+as' => 'status_name'
		});
		$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
		$order = $rs->single();
	}
	return error404() unless $f && $order;
	$order->{createtime} = timeToText($order->{createtime});
	my $ss = sub { my ($id, $c, $p) = split(':', $_[0]); ($id => { count => $c, price => $p }); }; 
	my %items = map $ss->($_), split(';', $order->{items});
	my $price = 0;
	$price += $_->{price} * $_->{count} foreach values %items;
	
	my $rs = db()->resultset('ItemJoined')->search({
		id => [ map { (split(':', $_))[0] } split(';', $order->{items}) ]
	}, {
		rows => 10, page => isParamUInt('page') ? param('page') : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @items = $rs->all();
	foreach (@items) {
		$_->{price} = $items{$_->{id}}->{price};
		$_->{count} = $items{$_->{id}}->{count};
	}
	template 'cabinet/orders/order', {
		order => $order,
		items => [@items],
		price => $price,
		pages => $rs->pager()->last_page
	};
};

prefix undef;

true;