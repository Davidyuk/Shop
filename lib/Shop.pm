package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Manager;

our $VERSION = '0.1';

hook before => sub {
	var menu => [
		{ name => 'Каталог', href => '/' },
		{ name => 'Корзина', href => '/cart/' },
		{ name => 'Оформить заказ', href => '/order/' },
		{ name => 'Магазины', href => '/stores/' }
	];
	session messages => [] if (! defined session('messages'));
	#my @array = qw(/login /logout);
	session path_info => request->path_info if ! (request->path_info ~~ ['/login', '/logout', '/register', '/cabinet/'] );
};

hook after_layout_render => sub {
	session messages => [];
};

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

get '/stores/' => sub {
	template 'index';
};

load 'catalog.pl', 'users.pl', 'cart.pl';

true;
