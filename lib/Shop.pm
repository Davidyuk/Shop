package Shop;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use Shop::Admin;
use Shop::Manager;

binmode(STDERR,':utf8');

our $VERSION = '0.1';

our $menu = [];
our $messages = [];

hook before => sub {
	if (request->path_info =~ /^\/cabinet\// && ! defined session('user_id') ) {
		addMessage('Страница доступна только после входа в систему.', 'danger');
		return redirect '/login';
	}
	if (request->path_info =~ /^\/cabinet\/\/admin/ && session('user_role') ne 'admin' ||
		request->path_info =~ /^\/cabinet\/\/manager/ && session('user_role') ne 'admin' && session('user_role') ne 'manager') {
		addMessage('Отсутствуют необходимые права доступа.', 'danger');
		return redirect session('path_info');
	}
};

hook before_template_render => sub {
	var menu => $menu;
	var messages => $messages;
	
	session cart => {} if ! defined session('cart');
	
	my @no_redirect_links = qw(/login /logout /register /cabinet/ /cart/ajax);
	session path_info => request->path_info if ! (request->path_info ~~ @no_redirect_links );
};

hook after_layout_render => sub {
	$messages = [];
};

get '/' => sub {
	redirect '/catalog';
};

load 'catalog.pl', 'cart.pl', 'stores.pl', 'users.pl', 'orders.pl';

true;
