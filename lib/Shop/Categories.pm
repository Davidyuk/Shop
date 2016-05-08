package Shop::Categories;
use Dancer ':syntax';
use Shop::DB;
use strict;
use warnings;

my @trees;
sub getTree {
	my $showEmptyCategories = shift;
	$showEmptyCategories = false unless defined $showEmptyCategories;
	return $trees[$showEmptyCategories] if defined $trees[$showEmptyCategories];
	my $rs = db()->resultset($showEmptyCategories ? 'Category' : 'CategoryJoined')->search(undef, {
		order_by => { -asc => 'name' }
	});
	my @arr = ();
	while (my $category = $rs->next) {
		my ($parent, $id) = ((split(/,/, $category->location))[-1], $category->id);
		$arr[$id] = {} unless $arr[$id];
		$arr[$id]->{id} = $category->id;
		$arr[$id]->{name} = $category->name;
		$arr[$id]->{count} = $category->count if !$showEmptyCategories;
		$arr[$parent]->{content} = [] unless $arr[$parent]->{content};
		push $arr[$parent]->{content}, $arr[$id];
	}
	setItemsCount($arr[0]->{content}) if !$showEmptyCategories;
	$trees[$showEmptyCategories] = $arr[0]->{content};
	return $trees[$showEmptyCategories];

	sub setItemsCount {
		my $content = shift;
		my $sum = 0;
		$sum += $_->{'count'} += setItemsCount($_->{'content'}) foreach @$content;
		@$content = grep { $_->{count} } @$content;
		return $sum;
	}
}

sub getBranchIds {
	my $id = shift;
	my $category = db()->resultset('Category')->find($id);
	return undef unless $category;
	my $loc = $category->location.','.$id;
	my $rs = db()->resultset('Category')->search({
		location => [ $loc, { like => $loc.',%' } ]
	});
	return [$rs->get_column('id')->all(), $id];
}

sub getBreadcrumbs {
	my $id = shift;
	my $category = db()->resultset('Category')->find($id);
	return undef unless $category;
	my $rs = db()->resultset('Category')->search({
		id => [ split(/,/, $category->location) ]
	});
	return [$rs->all(), { id => $id, name => $category->name, is_last => true }];
}

sub resetTree {
	$trees[false] = undef;
	$trees[true] = undef;
}

1;
