use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;

my $default_path = '/';

get '/login' => sub {
	template 'login', { title => 'Вход' };
};

post '/login' => sub {
	my $user = db()->resultset('User')->search({ 'email' => param('email') }, undef)->single();
	if ($user) {
		session user_id => $user->id;
		session user_name => getUserName($user);
		session user_role => $user->role;
		addMessage('Добро пожаловать, ' . session('user_name') . '.', 'success');
		return redirect session('path_info') || $default_path;
	}	
	addMessage('Неверное имя пользователя или пароль. Проверьте правильность введенных данных.', 'danger');
	template 'login', { title => 'Вход' };
};

get '/logout' => sub {
	my $path = session('path_info');
	session->destroy;
	addMessage('Вы успешно вышли из системы.', 'info');
	redirect $path || $default_path;
};

get '/register' => sub {
	template 'register', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js' ],
		title => 'Регистрация'
	};
};

post '/register' => sub {
	my ($valid, $user) = (true, undef);
	addMessage('Адрес электронной почты не указан.', 'danger') unless isParamNEmp('email') || ($valid = false);
	$user = db()->resultset('User')->search({ 'email' => param('email') }, undef)->single if $valid;
	addMessage('Пользователь с email: <strong>' . param('email') . '</strong> уже зарегистрирован в системе.', 'danger') if $user;
	addMessage('Пустые пароли запрещены.', 'danger') unless isParamNEmp('password') || ($valid = false);
	addMessage('Пароли не совпадают.', 'danger') unless param('password') eq param('password_rep') || ($valid = false);
	if ($valid && !$user) {
		$user = db()->resultset('User')->create({
			email => param('email'),
			passhash => param('password'),
			salt => 'my salt',
			role => 'user',
			name => param('name'),
			sname => param('sname'),
			payment => param('payment'),
			address => param('address')
		});
		session user_id => $user->id;
		session user_name => getUserName($user);
		session user_role => $user->role;
		addMessage('Вы успешно зарегистрировались, ' . session('user_name') . '.', 'success');
		return redirect session('path_info') || $default_path;
	}
	template 'register', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js' ],
		title => 'Регистрация'
	};
};

get '/cabinet' => sub {
	template 'cabinet', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js' ],
		title => 'Личный кабинет',
		user => db()->resultset('User')->find(session('user_id'))
	};
};

post '/cabinet' => sub {
	my $user = db()->resultset('User')->find(session('user_id'));
	if (isParamNEmp('action')) {
		if (param('action') eq 'user_info') {
			$user->email(param('email'));
			$user->name(param('name'));
			$user->sname(param('sname'));
			$user->payment(param('payment'));
			$user->address(param('address'));
			session user_name => getUserName($user);
			addMessage('Изменения сохранены.', 'info');
		} elsif (param('action') eq 'password') {
			if ($user->passhash eq param('password_old')) {
				$user->passhash(param('password'));
				addMessage('Пароль изменён.', 'info');
			} else {
				addMessage('Неправильно указан старый пароль.', 'danger');
			}
		}
		$user->update;
	}
	template 'cabinet', {
		styles => [ 'jquery.kladr.min.css' ],
		scripts => [ 'jquery.kladr.min.js' ],
		title => 'Личный кабинет',
		user => $user
	};
};

sub getUserName {
	my $user = shift;
	my $name = $user->name . ' ' . $user->sname;
	$name =~ s/^\s+|\s+$//g;
	$name = $user->email unless $name;
	return $name;
}
