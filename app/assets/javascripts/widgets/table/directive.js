app.directive("table", ["$http", "TableModel", function($http, TableModel) {

  function link(scope, element, attrs) {

    function jsLink(input) {
      return input.replace(new RegExp('\\[([^\\]]+)\\]\\(([^\\)]+)\\)', 'mg'), '<a onClick="$.ajax({url: \'$2\'})" href="#">$1</a>')
    }

    function formatRows(rows) {
      return rows.map(function(r) { return r.map(function(s) { return jsLink(s)})});
    }

    function onSuccess(data) {
      var datatable;

      scope.data = data;
      if (datatable = scope.datatable) {
        datatable.fnClearTable();
        datatable.fnAddData(formatRows(data.rows));
      } else {
        datatable = $(element).find("table").dataTable({
          "aaData": formatRows(data.rows),
          "aoColumns": data.columns.map(function(c) { return {sTitle: c}; }),
          "bAutoWidth": false,
          "iDisplayLength": scope.widget.displayed_rows,
          "bLengthChange": false
        });
        scope.datatable = datatable;
      }
    }

    function update() {
      return TableModel.getData(scope.widget).success(onSuccess);
    }

    scope.init(update);

    // changing the widget config should redraw the datatable
    scope.$watch("widget.displayed_rows", function(newValue, oldValue) {
      if (newValue !== oldValue) {
        scope.datatable.fnSettings()._iDisplayLength = newValue;
        scope.datatable.fnDraw();
      }
    });

  }

  return {
    template: '<table cellpadding="0" cellspacing="0" border="0" class="display"></table>',
    link: link
  };
}]);
