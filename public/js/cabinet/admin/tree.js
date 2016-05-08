jQuery(document).ready(function($) {
	$.ajaxSetup({
		url: '/cabinet/admin/categories',
		dataType: 'json',
		error: networkError
	});
	$('#jstree').on('create_node.jstree', function (obj, val) {
		$.ajax({ type: 'POST', data: {
			name: val.node.text,
			parent_id: val.parent == '#' ? 0 : val.parent }
		});
	}).on('rename_node.jstree', function (obj, val) {
		console.log('Rename! ' + val.text);
	}).on('delete_node.jstree', function (obj, val) {
		console.log('Delete! ' + val);
	}).on('move_node.jstree', function(obj, par){
		console.log('Moved: ' + par.node.id + ' from ' + par.old_parent + ' to ' + par.parent);
	}).jstree({
		core: {
			check_callback: true,
			data: function(obj, cb) {
				$.getJSON('/cabinet/admin/categories', function(data) {
					$.each(data, preproc);
					cb.call(this, data);
					function preproc(id, node) {
						node['text'] = node['name'];
						node['children'] = node['content'];
						node['name'] = node['content'] = undefined;
						if (node.children)
							$.each(node.children, preproc);
					}
				});
			},
			check_callback: function(operation, node, node_parent, node_position, more) {
				switch (operation) {
					case 'delete_node':
						return confirm('Вы уверены, что хотите удалить эту категорию?');
					case 'move_node':
						return node.parent != node_parent.id;
					case 'create_node':
					case 'rename_node':
						return true;
					case 'copy_node':
				}
				return false;
			}
		},
		plugins: ['contextmenu', 'dnd', 'sort'],
		contextmenu: {
			items: function(node) {
				var result = $.jstree.defaults.contextmenu.items(node);
				result.ccp = undefined;
				$.extend(result, { });
				$.extend(result.create, { label: 'Создать' });
				$.extend(result.rename, { label: 'Переименовать' });
				$.extend(result.remove, { label: 'Удалить', _disabled: node.children.length ? true : false });
				return result;
			}
		},
		dnd: {
			check_while_dragging: true
		}
	});
	$('#category_create').click(function() {
		var ref = $('#jstree').jstree(true);
		ref.edit(ref.create_node(null));
	});
});