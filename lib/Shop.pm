package Shop;
use Dancer ':syntax';
use Shop::DB qw(db);
use Shop::Manager;

our $VERSION = '0.1';

hook before => sub {
	var menu => [
		{ name => 'Каталог', href => '/' },
		{ name => 'Корзина', href => '/cart/' },
		{ name => 'Магазины', href => '/stores', dropdown => getStoresList() }
	];
	session messages => [] if (! defined session('messages'));
	#my @array = qw(/login /logout);
	session path_info => request->path_info if ! (request->path_info ~~ ['/login', '/logout', '/register', '/cabinet/', '/cartajax'] );
};

hook after_layout_render => sub {
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
	template 'stores', {
		(defined param('id') && param('id') ne '') ?
			( store => db()->resultset('Store')->find(param('id')) ) :
			( stores => getStoresList() )
	};
};

load 'catalog.pl', 'users.pl', 'cart.pl';

true;
