app.directive("table", ["$http", "TableModel", function($http, TableModel) {

  function link(scope, element, attrs) {

    function onSuccess(data) {
      scope.data = data;
    }

    function update() {
      return TableModel.getData(scope.widget).success(onSuccess);
    }

    scope.init(update);
  }

  return {
    template: $("#templates-widgets-table-show").html(),
    link: link
  };
}]);
