package Shop::Admin::Categories;

use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Shop::Categories;
use JSON qw//;

get '/categories' => sub {
    template 'cabinet/admin/categories', {
		menu => $menu
	};
};

ajax '/categories' => sub {
	unless (request->is_post) {
		return JSON::to_json Shop::Categories::getTree(true);
	} else {
		my $parent;
		return 'Ошибка' unless isParamNEmp('name')
			&& isParamUInt('parent_id') && ($parent = db()->resultset('Category')->find(param('parent_id')));
		Shop::Categories::resetTree;
		return db()->resultset('Category')->create({
			name => param('name'),
			location => $parent->location . ',' . param('parent_id')
		})->id;
	}
};

put '/categories' => sub {
	my ($node, $parent);
	return 'Ошибка' unless isParamNEmp('name')
		&& isParamUInt('parent_id') && ($parent = db()->resultset('Category')->find(param('parent_id')))
		&& isParamUInt('id') && ($node = db()->resultset('Category')->find(param('id')));
	$node->name(param('name'));
	my $new_location = $parent->location . ',' . param('parent_id');
	if ($node->location ne $new_location) {
		my $rs = db()->resultset('Category')->search({
			-or => {
				'location' => { like => $node->location.'.%' },
				'location' => $node->location
			}
		});
		while (my $child = $rs->next) {
			my $str = $child->location;
			substr($str, 0, strlen($node->location)) = $new_location;
			$child->location($str);
			$child->update;
		}
		$node->location($new_location);
	}
	$node->update;
	Shop::Categories::resetTree;
	return '';
};

del '/categories' => sub {
	my ($node, $parent);
	return 'Ошибка' unless isParamNEmp('name')
		&& isParamUInt('id') && ($node = db()->resultset('Category')->find(param('id')));
	return 'Ошибка: Узел имеет дочерние категории' if getCategoriesIds($node->id);
	return 'Ошибка: Существуют товары связанные с текущей или дочерними категориями' if db()->resultset('Items')->search({
		category_id => getCategoriesIds($node->id)
	})->single;
	$node->delete;
	Shop::Categories::resetTree;
	return '';
};

true;
