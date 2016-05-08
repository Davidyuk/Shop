package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;

use Shop::User;
use Shop::Orders;
use Shop::Manager;
#use Shop::Admin;

binmode(STDERR,':utf8');

our $VERSION = '0.1';

our $menu = [];

hook before_template_render => sub {
	var menu => $menu;
};

hook after_template_render => sub {
	session messages => [];
};

get '/' => sub {
	redirect '/catalog';
};

load 'catalog.pl', 'cart.pl', 'stores.pl';

any qr{.*} => sub {
	return error404();
};

true;
