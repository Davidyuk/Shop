package Shop::Manager;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use utf8;
use Shop::Schema;
use JSON qw//;

prefix '/cabinet/manager';

get '' => sub {
	my $rs = db()->resultset('UsersStore')->search({ user_id => session('user_id') }, {
		join => 'store',
		'+select' => 'store.name',
		'+as' => 'store_name',
	});
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'manager', {
		styles => [
			'jsgrid.min.css',
			'jsgrid-theme.min.css'
		],
		scripts => [ 'jsgrid.min.js', 'manager.js' ],
		stores => [ $rs->all() ],
		title => 'Управление магазинами'
	};
};

get '/categories' => sub {
	my $rs = db()->resultset('Category')->search(undef, {
		'select' => ['id', 'name'],
	});
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

post '/ajax' => sub {
	return status 400 unless isParamUInt('item_id') && isParamUInt('store_id') && isParamUInt('count');
	my $item = {
		item_id => param('item_id'),
		store_id => param('store_id'),
		count => param('count')
	};
	db()->resultset('ItemsStore')->create($item);
	
	my $rs = db()->resultset('ItemsStore')->search($item, {
		join => ['item'],
		'select' => ['item_id', 'store_id', 'count', 'item.name', 'item.price', 'item.category_id'],
		'as' => ['item_id', 'store_id', 'count', 'name', 'price', 'category_id']
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

put '/ajax' => sub {
	return status 400 unless isParamUInt('item_id') && isParamUInt('store_id') && isParamUInt('count');
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
	db()->resultset('ItemsStore')->search({
		item_id => param('item_id'),
		store_id => param('store_id')
	})->delete_all();
	return '';
};

get '/ajax' => sub {
	return status 400 unless isParamUInt('store_id');
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