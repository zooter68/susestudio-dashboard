app.factory("TableModel", ["$http", "TimeSelector", function($http, TimeSelector) {

  function getParams(config) {
    return {
      from: TimeSelector.getFrom(config.range),
      to: TimeSelector.getCurrent(config.range),
      source: config.source,
      widget_id: config.id
    };
  }

  function getData(config) {
    return $http.get("/api/data_sources/table", { params: getParams(config) });
  }

  return {
    getData: getData
  };
}]);
