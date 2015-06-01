use utf8;

our $default_path = '/';

sub getUserName {
	my $user = shift;
	return $user->name . ' ' . $user->sname;
}

post '/login' => sub {
	my $db = Shop::DB::db();
	
	my $user = $db->resultset('User')->search({
		'email' => params->{email}
	}, undef)->single();
	if (defined $user) {
		session user_id => $user->id;
		session user_name => getUserName($user);
		session user_role => $user->role;
		session messages => [@{session->{messages}}, {
			text => 'Добро пожаловать, ' . session('user_name') . '.',
			type => 'success'
		}];
		
		redirect session('path_info') || $default_path;
		return;
	}
	
	session messages => [@{session->{messages}}, {
		text => 'Неверное имя пользователя или пароль. Проверьте правильность введенных данных.',
		type => 'danger'
	}];
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
	session messages => [@{session->{messages}}, {
		text => 'Вы успешно вышли из системы.',
		type => 'info'
	}];
	redirect $path || $default_path;
};

post '/register' => sub {
	my $valid = true;
	
	print STDERR 'DEBUF'.param('email');
	if (param('email') eq '') {
		session messages => [@{session->{messages}}, {
			text => 'Адрес электронной почты не указан.',
			type => 'danger'
		}];
		$valid = false;
	}
	if (param('password') eq '') {
		session messages => [@{session->{messages}}, {
			text => 'Пустые пароли запрещены.',
			type => 'danger'
		}];
		$valid = false;
	}
	if (param('password') != param('password_rep')) {
		session messages => [@{session->{messages}}, {
			text => 'Пароли не совпадают.',
			type => 'danger'
		}];
		$valid = false;
	}
	
	if ($valid) {
		my $db = Shop::DB::db();
		my $user = $db->resultset('User')->search({
			'email' => params->{email}
		}, undef)->single;
		if (! defined $user) {
			my $user = $db->resultset('User')->create({
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
			session messages => [@{session->{messages}}, {
				text => 'Вы успешно зарегистрировались, ' . session('user_name') . '.',
				type => 'success'
			}];
		} else {	
			session messages => [@{session->{messages}}, {
				text => 'Пользователь с email: <strong>' . param('email') . '</strong> уже зарегистрирован в системе.',
				type => 'danger'
			}];
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
	my $db = Shop::DB::db();
	my $user = $db->resultset('User')->find(session('user_id'));
	if (param('action') eq 'user_info') {
		$user->email(param('email'));
		$user->name(param('name'));
		$user->sname(param('sname'));
		$user->payment(param('payment'));
		$user->address(param('address'));
		session user_name => getUserName($user);
		session messages => [@{session->{messages}}, {
			text => 'Изменения сохранены.',
			type => 'info'
		}];
	} elsif (param('action') eq 'password') {
		if ($user->passhash eq param('password_old')) {
			$user->passhash(param('password'));
			session messages => [@{session->{messages}}, {
				text => 'Пароль изменён.',
				type => 'info'
			}];
		} else {
			session messages => [@{session->{messages}}, {
				text => 'Неправильно указан старый пароль.',
				type => 'danger'
			}];
		}
	}
	$user->update;
	var user => $user;
	template 'cabinet', {
		title => 'Личный кабинет',
		header => 'Личный кабинет'
	};
};

get '/cabinet/' => sub {
	if (! defined session('user_id')) {
		session messages => [@{session->{messages}}, {
			text => 'Для доступа в этот раздел требуется регистрация.',
			type => 'danger'
		}];
		redirect '/login';
		return;
	}
	my $db = Shop::DB::db();
	var user => $db->resultset('User')->find(session('user_id'));
	template 'cabinet', {
		title => 'Личный кабинет',
		header => 'Личный кабинет'
	};
};