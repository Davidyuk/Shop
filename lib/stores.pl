use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

push $Shop::menu, { name => 'Магазины', href => '/stores', dropdown => getStoresList() };

get '/stores' => sub {
	template 'stores', {
		title => 'Магазины',
		stores => getStoresList()
	};
};

get '/stores/:id' => sub {
	my $store;
	return template 'stores', {
		store => $store,
		title => $store->name
	} if param('id') =~ m/^\d+$/ && ($store = db()->resultset('Store')->find(param('id')));
	error404();
};

my $storesList;
sub getStoresList {
	return $storesList if defined $storesList;
	my $rs = db()->resultset('Store')->search(undef, { order_by => 'name' });
	my (@s, $t);
	push @s, { name => $t->name, href => $t->id } while ($t = $rs->next);
	$storesList = [@s];
	return $storesList;
}

true;