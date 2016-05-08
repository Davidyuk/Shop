jQuery(document).ready(function($) {
	var options = {
		searchModeButtonTooltip: 'Переключить для поиска',
		insertModeButtonTooltip: 'Переключить для добавления',
		editButtonTooltip: 'Редактировать',
		deleteButtonTooltip: 'Удалить',
		searchButtonTooltip: 'Поиск',
		clearFilterButtonTooltip: 'Очистить фильтр',
		insertButtonTooltip: 'Добавить',
		updateButtonTooltip: 'Обновить',
		cancelEditButtonTooltip: 'Отменить редактирование'
	}
	$.extend(jsGrid.fields.control.prototype, options);
	options = {
		width: '100%',
		height: '800px',
		pagerFormat: 'Страницы: {first} {prev} {pages} {next} {last} &nbsp;&nbsp; {pageIndex} из {pageCount}',
		pagePrevText: '<span class="glyphicon glyphicon-triangle-left"></span>',
		pageNextText: '<span class="glyphicon glyphicon-triangle-right"></span>',
		pageFirstText: '<span class="glyphicon glyphicon-backward"></span>',
		pageLastText: '<span class="glyphicon glyphicon-forward"></span>',
		loadMessage: 'Пожалуйста, подождите...',
		deleteConfirm: 'Вы уверены?',
		noDataContent: 'Не найдено',
		sorting: true,
		filtering: true,
		inserting: true,
		editing: true,
		selecting: false,
		paging: true,
		pageLoading: true,
		autoload: true,
		pageSize: 20,
	}
	$.extend(jsGrid.Grid.prototype, options);
});