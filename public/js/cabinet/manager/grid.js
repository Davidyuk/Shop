jQuery(document).ready(function($) {	
	var categories;
	$.getJSON('/cabinet/manager/categories', function(data){
		data.unshift({ id: 0, name: '' });
		categories = data;
		$('.grid-stores li a').click(function() {
			$('.grid-stores .active').removeClass('active');
			RebuildGrid( $(this).parent().addClass('active').data('store') );
		}).filter(window.location.hash ? '[href=' + window.location.hash + ']' : '*').first().trigger('click');
	}).error(networkError);
	
	$.ajaxSetup({
		url: '/cabinet/manager/ajax',
		dataType: 'json',
		error: networkError
	});
	var grid;
	function RebuildGrid(storeId) {
		if (grid) $("#grid").jsGrid("destroy");
		grid = $('#grid').jsGrid({
			fields:[
				{ width: '30px', name: 'item_id', type: 'number', title: 'Артикул'},
				//{ width: '30px', name: 'store_id', type: 'number', title: 'Магазин'},
				{ editing: 0, name: 'name', type: 'text', title: 'Название'},
				{ width: '30px', editing: 0, name: 'price', type: 'number', title: 'Стоимость'},
				{ width: '30px', editing: 0, name: 'category_id', type: 'select', title: 'Категория', items: categories, valueField: 'id', textField: 'name' },
				{ width: '30px', name: 'count', type: 'number', title: 'Количество'},
				{ type: 'control' }
			],
			controller: {
				loadData: function(filter) {
					filter.store_id = storeId;
					return $.ajax({ type: 'GET', data: filter });
				},
				insertItem: function(item) {
					item.store_id = storeId;
					return $.ajax({ type: 'POST', data: item });
				},
				updateItem: function(item) {
					var d = $.Deferred();
					$.ajax({ type: 'PUT', data: item }).done(function(response) {
						d.resolve(response);
					});		
					return d.promise();
					return {
						category_id: 2,
						count: 47,
						store_id: 9,
						name: "QWE",
						price: 34490,
						item_id: 8
					};
				},
				deleteItem: function(item) {
					$.ajax({ type: 'DELETE', dataType: 'html', data: item });
				}
			}
		});
	}
});