use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

push $Shop::menu, { name => 'Каталог', href => '/catalog' };

get '/catalog' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		isParamNEmp('search')	? ( 'me.name' => { like => '%'.param('search').'%' } ) : () ,
		isParamUInt('category')	? ( category_id => getCategoriesIds(param('category')) ) : ()
	}, {
		rows => 15, page => isParamUInt('page') ? param('page') : 1 
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	template 'catalog', {
		title => 'Каталог',
		hide_header => 1,
		breadcrumbs => isParamUInt('category') ? getCategoriesBreadcrumbs(param('category')) : undef,
		items => [$rs->all()],
		pages => $rs->pager()->last_page,
		categories => getCategoriesTree()
	};
	
	sub getCategoriesIds {
		my $id = shift;
		my $category = db()->resultset('Category')->find($id);
		return undef unless $category;
		my $loc = $category->location.','.$id;
		my $rs = db()->resultset('Category')->search({
			location => [ $loc, { like => $loc.',%' } ]
		});
		$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
		return [$rs->get_column('id')->all(), $id];
	}
};

get '/catalog/:id' => sub {
	my $item;
	return template 'item', {
		title => $item->name,
		breadcrumbs => getCategoriesBreadcrumbs($item->category_id),
		item => $item
	} if param('id') =~ m/^\d+$/ && ($item = db()->resultset('ItemJoined')->search(
		{ id => param('id') }, undef)->single());
	error404();
};


sub getCategoriesBreadcrumbs {
	my $id = shift;
	my $category = db()->resultset('Category')->find($id);
	return undef unless $category;
	my $rs = db()->resultset('Category')->search({
		id => [ split(/,/, $category->location) ]
	});
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	return [$rs->all(), { id => $id, name => $category->name, is_last => true }];
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
	setItemsCount($result->{'content'});
	$categoriesTree = $result->{'content'};
	return $categoriesTree;
	
	sub setItemsCount {
		my $content = shift;
		my $sum = 0;
		foreach (keys %$content) {
			$sum += $content->{$_}->{'count'} += setItemsCount($content->{$_}->{'content'});
			delete $content->{$_} unless $content->{$_}->{'count'};
		}
		return $sum;
	}
}

true;