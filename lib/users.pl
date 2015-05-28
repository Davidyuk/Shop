use utf8;

post '/login' => sub {
	template 'login', {
		title => 'Вход',
		header => 'Вход в систему',
		message => { text => "Неверное имя пользователя или пароль.", type => 'danger' }
	};
};

get '/login' => sub {
	template 'login', {
		title => 'Вход',
		header => 'Вход в систему',
	};
};

post '/register' => sub {
	my $t = param 'email';
	#forward "/?message=" . "Вы успешно зарегистрировались в системе" . $t;
	template 'register', {
		title => 'Регистрация',
		header => 'Регистрация',
		message => { text => "Вы успешно зарегистрировались в системе.", type => 'success' }
		#message => { text => "Пользователь с email: <strong>$t</strong> уже зарегистрирован в системе.", type => 'danger' }
	};
};

get '/register' => sub {
	template 'register', {
		title => 'Регистрация',
		header => 'Регистрация'
	};
};

get '/cabinet/' => sub {
	template 'cabinet', {
		title => 'Личный кабинет',
		header => 'Личный кабинет'
	};
};