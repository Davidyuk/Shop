package Shop::User;
use Dancer ':syntax';
use Shop::DB;
use Shop::Common;
use strict;
use warnings;
use utf8;
use Dancer::Plugin::Passphrase;

my $default_path = '/';

get '/login' => sub {
	template 'login';
};

post '/login' => sub {
	my $user = db()->resultset('User')->search({ 'email' => param('email') }, undef)->single();
	if ($user && passphrase(param('password'))->matches($user->password)) {
		session uid => $user->id;
		session name => getUserName($user);
		session role => $user->role;
		addMessage('Добро пожаловать, ' . session('name') . '.', 'success');
		return redirect session('path_info') || $default_path;
	}	
	addMessage('Неверное имя пользователя или пароль. Проверьте правильность введенных данных.', 'danger');
	template 'login';
};

get '/register' => sub {
	template 'register';
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
			password => passphrase(param('password'))->generate,
			role => 'user',
			name => param('name'),
			sname => param('sname'),
			payment => param('payment'),
			address => param('address')
		});
		session uid => $user->id;
		session name => getUserName($user);
		session role => $user->role;
		addMessage('Вы успешно зарегистрировались, ' . session('name') . '.', 'success');
		return redirect session('path_info') || $default_path;
	}
	template 'register';
};

hook before => sub {
	if (request->path_info =~ /^\/cabinet/ && ! defined session('uid') ) {
		addMessage('Страница доступна только после входа в систему.', 'danger');
		return redirect '/login';
	}
};

get '/cabinet' => sub {
	redirect '/cabinet/edit';
};

hook before => sub {
	session role => '' unless session('role');
	session path_info => $default_path unless session('path_info');
};

hook before_template => sub {
	my @arr = qw(/login /cabinet/logout /register /cabinet/);
	session path_info => request->path_info
		unless request->path_info ~~ @arr;
};

get '/cabinet/logout' => sub {
	my $path = session('path_info');
	session->destroy;
	addMessage('Вы успешно вышли из системы.', 'info');
	redirect $path || $default_path;
};

hook before_template => sub {
	addUserMenuItem({name => 'Редактирование профиля', href => '/cabinet/edit', icon => 'glyphicon-cog'});
};

get '/cabinet/edit' => sub {
	template 'cabinet/edit', {
		user => db()->resultset('User')->find(session('uid'))
	};
};

post '/cabinet/edit' => sub {
	my $user = db()->resultset('User')->find(session('uid'));
	if (isParamNEmp('action')) {
		if (param('action') eq 'user_info') {
			my ($valid, $user_check) = (true, undef);
			addMessage('Адрес электронной почты не указан.', 'danger') unless isParamNEmp('email') || ($valid = false);
			$user_check = db()->resultset('User')->search({ 'email' => param('email') }, undef)->single if $valid &&  $user->email ne param('email');
			addMessage('Пользователь с email: <strong>' . param('email') . '</strong> уже зарегистрирован в системе.', 'danger') if $user_check;
			if ($valid && !$user_check) {
				$user->email(param('email'));
				$user->name(param('name'));
				$user->sname(param('sname'));
				$user->payment(param('payment'));
				$user->address(param('address'));
				session user_name => getUserName($user);
				$user->update;
				addMessage('Изменения сохранены.', 'info');
			}
		} elsif (param('action') eq 'password') {
			my $valid = true;
			addMessage('Пустые пароли запрещены.', 'danger') unless isParamNEmp('password') || ($valid = false);
			addMessage('Пароли не совпадают.', 'danger') unless param('password') eq param('password_rep') || ($valid = false);
			addMessage('Неправильно указан старый пароль.', 'danger')
				unless passphrase(param('password_old'))->matches($user->password) || ($valid = false);
			if ($valid) {
				$user->password(passphrase(param('password'))->generate);
				$user->update;
				addMessage('Пароль изменён.', 'info');
			}
		}
	}
	template 'cabinet/edit', {
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
