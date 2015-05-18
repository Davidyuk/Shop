package Shop;
use Dancer ':syntax';
use Shop::DB;

our $VERSION = '0.1';

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

get '/' => sub {
    template 'index';
};

get '/item/' => sub {
	my $db = Shop::DB::db();
	my $item = $db->resultset('Catalog')->find(params->{'id'});
	my $rs = $db->resultset('Stock')->search({
		catalog_id => $item->id
	}, {
		join => 'store',
		'+select' => 'store.name',
		order_by => 'store.name',
		#rows => 30, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @stores = $rs->all();
	print STDERR Data::Dumper::Dumper( @stores );
    template 'item', {
		title => $item->name,
		item => $item,
		stores => \@stores
	};
};

sub getCategoriesBreadcrumbs {
	my $db = Shop::DB::db();
	my $category = $db->resultset('Category')->find($_[0]);
	return undef unless ($category);
	
	my $rs = $db->resultset('Category')->search({
		id => [ split(/,/, $category->location) ]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	
	return [$rs->all(), { name => $category->name }];
};

sub getCategoriesIds {
	my $db = Shop::DB::db();
	my $category = $db->resultset('Category')->find($_[0]);
	return undef unless ($category);
	
	my $loc = $category->location.','.$_[0];
	my $rs = $db->resultset('Category')->search({
		location => [ $loc, { like => $loc.',%' } ]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return [$rs->get_column('id')->all(), $_[0]];
}

get '/catalog/' => sub {
	my $db = Shop::DB::db();
	my $rs = $db->resultset('Catalog')->search({
		params->{'search'}		? ( 'me.name' => { like => '%'.params->{'search'}.'%' } ) : () ,
		params->{'category'}	? ( category_id => getCategoriesIds(params->{'category'}) ) : ()
	}, {
		join => 'category',
		'+select' => ['category.name'],
		order_by => ['category_id', 'price'],
		rows => 30, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @catalog = $rs->all();
	
	template 'catalog', {
		breadcrumbs => (params->{'category'}) ? getCategoriesBreadcrumbs(params->{'category'}) : undef,
		items => \@catalog,
		pages => $rs->pager()->last_page
	};
};

sub getCategoriesTree {
	my $db = Shop::DB::db();
	my $rs = $db->resultset('Category')->search(undef, {
		join => 'catalogs',
		'+select' => { count => 'catalogs.id' },
		'+as' => 'items',
		group_by => 'me.id'
	});
	my $result = { content => {} };
	while (my $category = $rs->next) {
		my (undef, @loc) = (split(/,/, $category->location), $category->id);
		my $h = $result;
		$h = $h->{'content'}->{$_} //= {} foreach @loc;
		$h->{'name'} = $category->name;
		$h->{'count'} = $category->get_column('items');
	}
	sub setItemsCount {
		my $content = shift;
		my $sum = 0;
		$sum += $content->{$_}->{'count'} += setItemsCount($content->{$_}->{'content'})
			foreach keys %$content;
		return $sum;
	}
	setItemsCount($result->{'content'});
	return $result->{'content'};
};

get '/categories/' => sub {
	template 'categories', {
		title => 'Все категории',
		categories => getCategoriesTree()
	};
};

true;
