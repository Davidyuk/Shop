use Shop::DB qw(db);
use utf8;

sub getCategoriesBreadcrumbs {
	my $category = db()->resultset('Category')->find($_[0]);
	return undef unless ($category);
	
	my $rs = db()->resultset('Category')->search({
		id => [ split(/,/, $category->location) ]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	
	return [$rs->all(), { id => $_[0], name => $category->name, is_last => true }];
};

sub getCategoriesIds {
	my $category = db()->resultset('Category')->find($_[0]);
	return undef unless ($category);
	
	my $loc = $category->location.','.$_[0];
	my $rs = db()->resultset('Category')->search({
		location => [ $loc, { like => $loc.',%' } ]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return [$rs->get_column('id')->all(), $_[0]];
}

my $categoriesTree;
sub getCategoriesTree {
	return $categoriesTree if defined $categoriesTree;
	my $rs = db()->resultset('CategoryJoined');
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
	$categoriesTree = $result->{'content'};
	return $result->{'content'};
};

get '/' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		params->{'search'}		? ( 'me.name' => { like => '%'.params->{'search'}.'%' } ) : () ,
		params->{'category'}	? ( category_id => getCategoriesIds(params->{'category'}) ) : ()
	}, {
		rows => 15, page => (params->{'page'}) ? params->{'page'} : 1 
	});
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
	my $rs = db()->resultset('ItemJoined')->search(
		{ id => params->{'id'} }, undef);
	my $item = $rs->next;
	if (defined $item) {
		template 'item', {
			title => $item->name,
			header => $item->name,
			breadcrumbs => getCategoriesBreadcrumbs($item->category_id),
			item => $item
		};
	} else {
		status 404;
		return halt; # TODO
	}
};