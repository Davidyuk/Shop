package Shop::Admin::Tables;

use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Shop::Categories;
use JSON qw//;

get 'table' => sub {
	template 'cabinet/admin/grid', {
		tables => [
			{name => 'Товары', table => 'items'},
			{name => 'Категории', table => 'categories'},
			{name => 'Пользователи', table => 'users'},
			{name => 'Заказы', table => 'orders'},
			{name => 'Статусы', table => 'statuses'},
			{name => 'Менеджеры', table => 'users_stores'},
			{name => 'Магазины', table => 'stores'},
			{name => 'Товары в магазинах', table => 'items_stores'}
		],
		menu => $menu
	};
};

ajax '/table' => sub {
  if (request->is_post) {
    return status 400 unless isParamNEmp('table') && $metadata->{param('table')};
	  my $source = Shop::Schema->source($metadata->{param('table')});
	  my $item = {};
	  foreach ($source->columns) {
	  	next unless defined param($_) && param($_);
		  $item->{$_} = param($_);
	  }
	  return JSON::to_json {
		  db()->resultset($metadata->{param('table')})
			  ->create($item)
			  ->get_columns
	    };
  } else {
    return status 400 unless isParamNEmp('table') && $metadata->{param('table')};
    my $source = Shop::Schema->source($metadata->{param('table')});
    my $where = {};
    my $sortFIeldValid = false;
    foreach ($source->columns) {
      $sortFIeldValid ||= isParamEq('sortField', $_);
      next unless defined param($_) && param($_);
      if ($_ eq 'id' || $_ eq 'role' || isParamUInt($_)) {
        $where->{$_} = param($_);
      } else {
        $where->{$_} = { like => '%'.param($_).'%' };
      }
    }
    my $is_page = isParamUInt('pageSize') && isParamUInt('pageIndex');
    my $rs = db()->resultset($metadata->{param('table')})->search($where, {
      $is_page ?
        ( rows => param('pageSize'), page => param('pageIndex') ) : (),
      $sortFIeldValid ?
        ( order_by => { isParamEq('sortOrder', 'desc') ? -desc : -asc => param('sortField') } )
      : ()
    });
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    return JSON::to_json {data => [$rs->all()], itemsCount => $rs->pager()->total_entries } if $is_page;
    return JSON::to_json [$rs->all()];
  }
};

put '/table' => sub {
	return status 400 unless isParamNEmp('table') && $metadata->{param('table')};
	my $source = Shop::Schema->source($metadata->{param('table')});
	my $item = {};
	$item->{$_} = param($_) foreach ($source->columns);
	return JSON::to_json {
		db()->resultset($metadata->{param('table')})
			->find(param('id'))->update($item)
			->get_columns
	};
};

del '/table' => sub {
	return status 400 unless isParamNEmp('table') && $metadata->{param('table')};
	my $source = Shop::Schema->source($metadata->{param('table')});
	my $where = {};
	$where->{$_} = param($_) foreach ($source->columns);
	db()->resultset($metadata->{param('table')})->search($where, undef)->delete_all();
	return '';
};

get '/reference' => sub {
	return status 400 unless isParamNEmp('table') && isParamNEmp('valueField')
		&& isParamNEmp('textField') && $metadata->{param('table')};
	my $rs = db()->resultset($metadata->{param('table')})->search(undef, {
		select => [param('valueField'), param('textField')],
		order_by => param('textField')
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return JSON::to_json [$rs->all()];
};

true;
