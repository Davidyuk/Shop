use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

push $Shop::menu, { name => 'Магазины', href => '/stores', dropdown => getStores() };

get '/stores' => sub {
	template 'stores', {
		stores => getStores()
	};
};

get '/stores/:id' => sub {
	if (isParamUInt('id') && (my $store = db()->resultset('Store')->find(param('id')))) {
		return template 'stores', {
			store => $store
		}
	}
	return error404();
};

my $stores;
sub getStores {
	return $stores if defined $stores;
	my $rs = db()->resultset('Store')->search(undef, { order_by => 'name' });
	my (@s, $t);
	push @s, { name => $t->name, href => $t->id } while ($t = $rs->next);
	return $stores = [@s];
}

true;