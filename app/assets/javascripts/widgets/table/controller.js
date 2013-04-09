app.controller("TableCtrl", ["$scope", "Sources", function($scope, Sources) {

  var defaults = {
    size_x: 2, size_y: 1,
    update_interval: 10,
    range: "30-minutes"
  };

  if (!$scope.widget.id) {
    _.extend($scope.widget, defaults);
  }

  $scope.datapointsSources = Sources.availableSources("datapoints");

  $scope.supportsTargetBrowsing = function() {
    return Sources.supportsTargetBrowsing($scope.widget);
  };

  $scope.editTargets = function() {
    var templateUrl    = "/assets/templates/targets/index.html";

    dialog.targets = $scope.widget.targets;
    dialog.open(templateUrl, "TargetsCtrl").then(convertTargetsArrayToString);
  };

  function convertTargetsArrayToString(result) {
    $scope.widget.targets = _.map(dialog.$scope.targets, function(t) {
      return t.content;
    }).join(";");
  }

}]);
