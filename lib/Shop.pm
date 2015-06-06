package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use Shop::Manager;

our $VERSION = '0.1';

hook before_layout_render => sub {
	printf STDERR 'Hello hook before';
	var menu => [
		{ name => 'Каталог', href => '/' },
		{ name => 'Корзина', href => '/cart/' },
		{ name => 'Магазины', href => '/stores', dropdown => getStoresList() }
	];
	session cart => {} if ! defined session('cart');
	
	my @no_redirect_links = qw(/login /logout /register /cabinet/ /cart/ajax);
	session path_info => request->path_info if ! (request->path_info ~~ @no_redirect_links );
	
	if (request->path_info =~ /^\/cabinet\// && ! defined session('user_id') ) {
		addMessage('Страница доступна только после входа в систему.', 'danger');
		return redirect '/login';
	}
};

hook after_layout_render => sub {
	printf STDERR 'Hello hook after_layout_render';
	session messages => [];
	
};

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

my $storesList;
sub getStoresList {
	return $storesList if defined $storesList;
	my $rs = db()->resultset('Store')->search(undef, { order_by => 'name' });
	my @stores = ();
	push @stores, { name => $_->name, href => '/stores?id='.$_->id } while ($_ = $rs->next);
	$storesList = [@stores];
	return $storesList;
}

get '/stores' => sub {
	my $store;
	template 'stores', {
		(param('id') && param('id') =~ m/^\d+$/ && ($store = db()->resultset('Store')->find(param('id')))) ?
			(
				store => $store,
				title => $store->name,
				header => $store->name
			) :
			(
				title => 'Магазины',
				header => 'Магазины',
				stores => getStoresList()
			)
	};
};

load 'catalog.pl', 'users.pl', 'cart.pl';

true;
