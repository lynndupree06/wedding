(function () {
  var app = angular.module('app-directives', []);

  app.directive('editItem', function() {
    return {
      restrict: 'E',
      transclude: true,
      templateUrl: 'edit-item.html'
    };
  });
})();