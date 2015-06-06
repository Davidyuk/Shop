use Shop::DB;
use Shop::Common;
use strict;
#use warnings;
use utf8;

our $default_path = '/';

sub getUserName {
	my $user = shift;
	my $name = $user->name . ' ' . $user->sname;
	$name =~ s/^\s+|\s+$//g;
	return $name;
}

post '/login' => sub {
	my $user = db()->resultset('User')->search({
		'email' => params->{email}
	}, undef)->single();
	if (defined $user) {
		session user_id => $user->id;
		session user_name => getUserName($user);
		session user_role => $user->role;
		addMessage('Добро пожаловать, ' . session('user_name') . '.', 'success');
		redirect session('path_info') || $default_path;
		return;
	}
	
	addMessage('Неверное имя пользователя или пароль. Проверьте правильность введенных данных.', 'danger');
	template 'login', {
		title => 'Вход',
		header => 'Вход в систему'
	};
};

get '/login' => sub {
	template 'login', {
		title => 'Вход',
		header => 'Вход в систему'
	};
};

get '/logout' => sub {
	my $path = session('path_info');
	session->destroy;
	addMessage('Вы успешно вышли из системы.', 'info');
	redirect $path || $default_path;
};

post '/register' => sub {
	my $valid = true;
	
	print STDERR 'DEBUF'.param('email');
	if (param('email') eq '') {
		addMessage('Адрес электронной почты не указан.', 'danger');
		$valid = false;
	}
	if (param('password') eq '') {
		addMessage('Пустые пароли запрещены.', 'danger');
		$valid = false;
	}
	if (param('password') != param('password_rep')) {
		addMessage('Пароли не совпадают.', 'danger');
		$valid = false;
	}
	
	if ($valid) {
		my $user = db()->resultset('User')->search({
			'email' => params->{email}
		}, undef)->single;
		if (! defined $user) {
			my $user = db()->resultset('User')->create({
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
		} else {
			addMessage('Пользователь с email: <strong>' . param('email') . '</strong> уже зарегистрирован в системе.', 'danger');
			$valid = false;
		}
	}
	
	if ($valid) {
		redirect session('path_info') || $default_path;
	} else {
		template 'register', {
			title => 'Регистрация',
			header => 'Регистрация'
		};
	}
};

get '/register' => sub {
	template 'register', {
		title => 'Регистрация',
		header => 'Регистрация'
	};
};

post '/cabinet/' => sub {
	my $user = db()->resultset('User')->find(session('user_id'));
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
	template 'cabinet', {
		title => 'Личный кабинет',
		header => 'Личный кабинет',
		user => $user
	};
};

get '/cabinet/' => sub {
	template 'cabinet', {
		title => 'Личный кабинет',
		header => 'Личный кабинет',
		user => db()->resultset('User')->find(session('user_id'))
	};
};

