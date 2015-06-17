package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use Shop::Manager;

binmode(STDERR,':utf8');

our $VERSION = '0.1';

our $menu = [];
our $messages = [];

hook before_template_render => sub {
	say STDERR 'Hello hook before ' . request->path_info;
	var menu => $menu;
	var messages => $messages;
	
	session cart => {} if ! defined session('cart');
	
	my @no_redirect_links = qw(/login /logout /register /cabinet/ /cart/ajax);
	session path_info => request->path_info if ! (request->path_info ~~ @no_redirect_links );
	
	if (request->path_info =~ /^\/cabinet\// && ! defined session('user_id') ) {
		addMessage('Страница доступна только после входа в систему.', 'danger');
		return redirect '/login';
	}
};

hook after_layout_render => sub {
	say STDERR 'Hello hook after_layout_render ' . request->path_info;
	$messages = [];
};

#require Data::Dumper;
#print STDERR Data::Dumper::Dumper( @list );

get '/' => sub {
	#template 'index';
	redirect '/catalog';
};

load 'catalog.pl', 'cart.pl', 'stores.pl', 'users.pl', 'orders.pl';

true;
