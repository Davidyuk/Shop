package Shop;
use Dancer ':syntax';
use Shop::DB;

our $VERSION = '0.1';

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

get '/' => sub {
    template 'index';
};

sub getCategoriesBreadcrumbs {
	my @res;
	my $db = Shop::DB::db();
	my $rs = $db->resultset('Category')->search({ id => $_[0] });
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @categories = $rs->all();
	return undef if ($#categories == -1);
	unshift @res, { name => $categories[0]->{'name'} };
	
	my @idList = split(/,/, $categories[0]->{'location'});
	$rs = $db->resultset('Category')->search({
		id => \@idList
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	@categories = $rs->all();
	unshift @res, @categories;
	return \@res;
};

sub getCategoriesIds {
	my $db = Shop::DB::db();
	my $rs = $db->resultset('Category')->search({ id => $_[0] });
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	my @categories = $rs->get_column('location')->all();
	return undef if ($#categories != 0);
	$categories[0] .= ','.$_[0];
	$rs = $db->resultset('Category')->search({
		location => { like => [$categories[0], $categories[0].',%'] }
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	@categories = $rs->get_column('id')->all();
	unshift @categories, $_[0];
	return \@categories;
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
	my $rs = $db->resultset('Category')->search({}, {
		join => 'catalogs',
		'+select' => [ { count => 'catalogs.id' } ],
		'+as' => ['items'],
		group_by => ['me.id']
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
	template 'categories', { 'categories' => getCategoriesTree() };
};

true;
