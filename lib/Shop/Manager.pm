package Shop::Manager;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use utf8;
use Shop::Schema;
use JSON qw//;

prefix '/cabinet/manager';

my $menu = [
	{name => 'Редактирование магазинов', href => '/cabinet/manager'},
	{name => 'Добавить товар', href => '/cabinet/manager/newitem'}
];

hook before => sub {
	unless (request->path_info !~ /^\/cabinet\/\/manager/ || session('role') ~~ ['admin', 'manager']) {
		addMessage('Отсутствуют необходимые права доступа.', 'danger');
		status 403;
		return redirect session('path_info');
	}
};

hook before_template => sub {
	addUserMenuItem({type => 'divider'}) if session('role') ~~ ['admin', 'manager'];
	addUserMenuItem({
		name => 'Управление магазинами',
		href => '/cabinet/manager',
		icon => 'glyphicon-stats'
	}) if session('role') ~~ ['admin', 'manager'];
};

get '' => sub {
	my $rs;
	if (session('role') eq 'manager') {
		$rs = db()->resultset('UsersStore')->search({
			user_id => session('uid')
		}, {
			join => 'store',
			'select' => ['store_id', 'store.name'],
			'as' => ['id', 'name'],
		});
	} else {
		$rs = db()->resultset('Store');
	}
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	session stores => [ $rs->get_column('id')->all ];
	template 'cabinet/manager/grid', {
		stores => [ $rs->all() ],
		menu => $menu
	};
};

any '/newitem' => sub {
	if (request->is_post) {
		my $valid = isParamUInt('category_id') && isParamUInt('price') && isParamNEmp('name');
		$valid &&= db()->resultset('Category')->find(param('category_id'))->id;
		if ($valid) {
			my $item = db()->resultset('Item')->create({
				name => param('name'),
				category_id => param('category_id'),
				price => param('price'),
			});
			addMessage('Товар успешно добавлен. Артикул: ' . $item->id . '.', 'success');
		} else {
			addMessage('Ошибка добавления товара.', 'danger');
		}
	}
	my $rs = db()->resultset('Category')->search(undef, {
		select => ['id', 'name'],
		order_by => 'name'
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'cabinet/manager/newitem', {
		menu => $menu,
		categories => [$rs->all()]
	};
};

get '/categories' => sub {
	my $rs = db()->resultset('Category')->search(undef, {
		select => ['id', 'name'],
		order_by => 'name'
	});
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

post '/ajax' => sub {
	return status 400 unless isParamUInt('item_id') && isParamUInt('store_id') && isParamUInt('count');
	return status 403 unless param('store_id') ~~ session('stores') || session('role') eq 'admin';
	my $item = {
		item_id => param('item_id'),
		store_id => param('store_id'),
		count => param('count')
	};
	db()->resultset('ItemsStore')->create($item);
	
	my $rs = db()->resultset('ItemsStore')->search($item, {
		join => ['item'],
		select => ['item_id', 'store_id', 'count', 'item.name', 'item.price', 'item.category_id'],
		as => ['item_id', 'store_id', 'count', 'name', 'price', 'category_id']
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

put '/ajax' => sub {
	return status 400 unless isParamUInt('item_id') && isParamUInt('store_id') && isParamUInt('count');
	return status 403 unless param('store_id') ~~ session('stores') || session('role') eq 'admin';
	my $key = {
		item_id => param('item_id'),
		store_id => param('store_id')
	};
	my $value = {
		count => param('count')
	};
	db()->resultset('ItemsStore')->find($key)->update($value);
	
	my $rs = db()->resultset('ItemsStore')->search($key, {
		join => ['item'],
		'select' => ['item_id', 'store_id', 'count', 'item.name', 'item.price', 'item.category_id'],
		'as' => ['item_id', 'store_id', 'count', 'name', 'price', 'category_id']
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

del '/ajax' => sub {
	return status 400 unless isParamUInt('item_id') && isParamUInt('store_id');
	return status 403 unless param('store_id') ~~ session('stores') || session('role') eq 'admin';
	db()->resultset('ItemsStore')->search({
		item_id => param('item_id'),
		store_id => param('store_id')
	})->delete_all();
	return '';
};

get '/ajax' => sub {
	return status 400 unless isParamUInt('store_id');
	return status 403 unless param('store_id') ~~ session('stores') || session('role') eq 'admin';
	my $where = { store_id => param('store_id') };
	my $sortFIeldValid = false;
	foreach ('item_id', 'store_id', 'count', 'name', 'price', 'category_id') {
		$sortFIeldValid ||= isParamEq('sortField', $_);
		next unless defined param($_) && param($_);
		if ($_ ne 'name') {
			$where->{$_} = param($_);
		} else {
			$where->{$_} = { like => '%'.param($_).'%' };
		}
	}
	my $is_page = isParamUInt('pageSize') && isParamUInt('pageIndex');
	
	my $rs = db()->resultset('ItemsStore')->search($where, {
		join => ['item'],
		'select' => ['item_id', 'store_id', 'count', 'item.name', 'item.price', 'item.category_id'],
		'as' => ['item_id', 'store_id', 'count', 'name', 'price', 'category_id'],
		$is_page ?
			( rows => param('pageSize'), page => param('pageIndex') ) : (),
		$sortFIeldValid ? 
			( order_by => { isParamEq('sortOrder', 'desc') ? -desc : -asc => param('sortField') } )
		: ()
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json {data => [$rs->all()], itemsCount => $rs->pager()->total_entries } if $is_page;
	return JSON::to_json [$rs->all()];
};

prefix undef;

true;