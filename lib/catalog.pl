use utf8;

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

sub getCategoriesTree {
	my $db = Shop::DB::db();
	my $rs = $db->resultset('CategoryJoined');
	my $result = { content => {} };
	while (my $category = $rs->next) {
		my (undef, @loc) = (split(/,/, $category->location), $category->id);
		my $h = $result;
		$h = $h->{'content'}->{$_} //= {} foreach @loc;
		$h->{'name'} = $category->name;
		$h->{'count'} = $category->count;
	}
	sub setItemsCount {
		my $content = shift;
		my $sum = 0;
		foreach $_(keys %$content) {
			$sum += $content->{$_}->{'count'} += setItemsCount($content->{$_}->{'content'});
			delete $content->{$_} if ! $content->{$_}->{'count'};
		}
		return $sum;
	}
	setItemsCount($result->{'content'});
	return $result->{'content'};
};

get '/' => sub {
	my $db = Shop::DB::db();
	
	my $rs = $db->resultset('CatalogJoined')->search({
		params->{'search'}		? ( 'me.name' => { like => '%'.params->{'search'}.'%' } ) : () ,
		params->{'category'}	? ( category_id => getCategoriesIds(params->{'category'}) ) : ()
	}, {
		rows => 30, page => (params->{'page'}) ? params->{'page'} : 1 
	});
	#my $rs = $db->resultset('Catalog')->search({
	#	params->{'search'}		? ( 'me.name' => { like => '%'.params->{'search'}.'%' } ) : () ,
	#	params->{'category'}	? ( category_id => getCategoriesIds(params->{'category'}) ) : ()
	#}, {
	#	join => ['category', 'stocks'],
	#	+select => ['SUM(stocks.count)', 'id', 'name', 'price', 'category.name'],
	#	+as => ['SUM_stocks_count', 'id', 'name', 'price', 'category.name'],
	#	group_by => ['me.id'],
	#	rows => 30, page => (params->{'page'}) ? params->{'page'} : 1 
	#});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'catalog', {
		title => 'Каталог',
		breadcrumbs => (params->{'category'}) ? getCategoriesBreadcrumbs(params->{'category'}) : undef,
		items => [$rs->all()],
		pages => $rs->pager()->last_page,
		categories => getCategoriesTree()
	};
};

get '/item/' => sub {
	my $db = Shop::DB::db();
	my $rs = $db->resultset('CatalogJoined')->search(
		{ id => params->{'id'} }, undef);
	my $item = $rs->next;
	if (defined $item) {
		template 'item', {
			title => $item->name,
			header => $item->name,
			item => $item
		};
	} else {
		status 404;
		return halt; # TODO
	}
};