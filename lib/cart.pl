use utf8;

get '/order/' => sub {
	template 'order', {
		title => 'Оформить заказ',
		header => 'Оформить заказ'
	};
};

get '/shopcart/' => sub {
	template 'shopcart', {
		title => 'Корзина',
		header => 'Корзина'
	};
};