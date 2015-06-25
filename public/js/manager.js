jQuery(document).ready(function($) {
	jsGrid.fields.control.prototype.searchModeButtonTooltip = 'Переключить для поиска';
	jsGrid.fields.control.prototype.insertModeButtonTooltip = 'Переключить для добавления';
	jsGrid.fields.control.prototype.editButtonTooltip = 'Редактировать';
	jsGrid.fields.control.prototype.deleteButtonTooltip = 'Удалить';
	jsGrid.fields.control.prototype.searchButtonTooltip = 'Поиск';
	jsGrid.fields.control.prototype.clearFilterButtonTooltip = 'Очистить фильтр';
	jsGrid.fields.control.prototype.insertButtonTooltip = 'Добавить';
	jsGrid.fields.control.prototype.updateButtonTooltip = 'Обновить';
	jsGrid.fields.control.prototype.cancelEditButtonTooltip = 'Отменить редактирование';
	
	var categories;
	$.getJSON('/cabinet/manager/categories', function(data){
		data.unshift({ id: 0, name: '' });
		categories = data;
		$('.grid-stores li a').click(function() {
			$('.grid-stores .active').removeClass('active');
			RebuildGrid( $(this).parent().addClass('active').data('store') );
		}).filter(window.location.hash ? '[href=' + window.location.hash + ']' : '*').first().trigger('click');
	}).error(networkError);
	
	function RebuildGrid(storeId) {
		$.ajaxSetup({
			url: '/cabinet/manager/ajax',
			dataType: 'json',
			error: networkError
		});
		$('#grid').jsGrid({
			width: '100%',
			height: '800px',
			sorting: true,
			filtering: true,
			inserting: true,
			editing: true,
			paging: true,
			pageLoading: true,
			autoload: true,
			pageSize: 20,
			pagerFormat: 'Страницы: {first} {prev} {pages} {next} {last} &nbsp;&nbsp; {pageIndex} из {pageCount}',
			pagePrevText: '<span class="glyphicon glyphicon-triangle-left"></span>',
			pageNextText: '<span class="glyphicon glyphicon-triangle-right"></span>',
			pageFirstText: '<span class="glyphicon glyphicon-backward"></span>',
			pageLastText: '<span class="glyphicon glyphicon-forward"></span>',
			loadMessage: 'Пожалуйста, подождите...',
			deleteConfirm: 'Вы уверены?',
			noDataContent: 'Не найдено',
			fields:[
				{ width: '30px', editing: 0, name: 'item_id', type: 'number', title: 'Артикул'},
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
					return $.ajax({ type: 'PUT', data: item });
				},
				deleteItem: function(item) {
					$.ajax({ type: 'DELETE', dataType: 'html', data: item });
				}
			}
		});
	}
});