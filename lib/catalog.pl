use Shop::DB;
use Shop::Common;
use Shop::Categories;
use strict;
use warnings;
use utf8;

push $Shop::menu, { name => 'Каталог', href => '/catalog' };

get '/catalog' => sub {
	my $rs = db()->resultset('ItemJoined')->search({
		isParamNEmp('search')	? ( 'me.name' => { like => '%'.param('search').'%' } ) : () ,
		isParamUInt('category')	? ( category_id => Shop::Categories::getBranchIds(param('category')) ) : ()
	}, {
		rows => 15, page => isParamUInt('page') ? param('page') : 1
	});
	template 'catalog', {
		breadcrumbs => isParamUInt('category') ? Shop::Categories::getBreadcrumbs(param('category')) : undef,
		items => [$rs->all()],
		pages => $rs->pager()->last_page,
		categories => Shop::Categories::getTree
	};
};

get '/catalog/:id' => sub {
	if (
			isParamUInt('id') &&
			(my $item = db()->resultset('ItemJoined')->search({id => param('id')})->single())
		) {
		return template 'item', {
			item => $item,
			breadcrumbs => Shop::Categories::getBreadcrumbs($item->category_id)
		}
	}
	return error404();
};

true;
