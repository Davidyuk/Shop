package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Manager;

our $VERSION = '0.1';

hook 'before' => sub {
	var menu => [
		{ name => 'Каталог', href => '/' },
		{ name => 'Корзина <span class="badge">42</span>', href => '/shopcart/' },
		{ name => 'Оформить заказ', href => '/order/' },
		{ name => 'Магазины', href => '/stores/' }
	];
};

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

#post '/' => sub {
#	template 'index';
#};

get '/stores/' => sub {
	template 'index';
};

load 'catalog.pl', 'users.pl', 'cart.pl';

true;
