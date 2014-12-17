(function () {

  var app = angular.module('guestApp', ['ngRoute', 'ngResource', 'ngTable']);

  app.factory('Guests', ['$resource',function($resource){
    return $resource('/guests.json', {},{
      query: { method: 'GET', isArray: true },
      create: { method: 'POST' }
    })
  }]);

  app.factory('Guest', ['$resource', function($resource){
    return $resource('/guests/:id.json', {}, {
      show: { method: 'GET' },
      update: { method: 'PUT', params: {id: '@id'} },
      delete: { method: 'DELETE', params: {id: '@id'} }
    });
  }]);

  app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/guests',{
        templateUrl: '/index.html.erb',
        controller: 'GuestController'
      });
      $routeProvider.when('/guests/new', {
        templateUrl: '/index.html.erb',
        controller: 'NewGuestController'
      });
      $routeProvider.when('/guests/:id/edit', {
        templateUrl: '/index.html.erb',
        controller: "GuestUpdateController"
      });
      $routeProvider.otherwise({
        redirectTo: '/guests'
      });
    }
  ]);

//  app.controller('GuestController', ["$scope", "$http", '$resource', 'Guests', 'Guest', '$location', function ($scope, $http, $resource, Guests, Guest, $location) {
  app.controller('GuestController', ["$filter", "$scope", "$http", "ngTableParams", function ($filter, $scope, $http, ngTableParams) {
    $scope.view = 1;
    $scope.guests = [];
    $scope.orderByField = 'last_name';
    $scope.reverseSort = false;

    $http.get('guests_info')
      .success(function(data, status, headers, config) {
        $scope.guests = data;
        $scope.tableParams = new ngTableParams({
          page: 1,            // show first page
          total: data.length, // length of data
          count: 15          // count per page
        });

        $scope.$watch('tableParams', function(params) {
          var orderedData = params.sorting ?
            $filter('orderBy')(data, params.orderBy()) :
            data;

            $scope.guests = orderedData.slice((params.page - 1) * params.count, params.page * params.count);
        }, true);
      })
      .error(function(data, status, headers, config) {
        console.log("error", status);
      });

    $scope.editGuest = function(currentGuest) {
      $scope.view = 2;
      $scope.guest = currentGuest;
    };

    $scope.updateGuest = function(guest) {
      console.log("update");
      guest.updated_at = new Date();

//      $http.post('update_guest/', {})
//        .success(function(data, status, headers, config) {
//          console.log('success');
//        })
//        .error(function(data, status, headers, config) {
//          console.log("error", status);
//        });

      $http({
        method: 'POST',
        url: 'guests/' + guest.id,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        transformRequest: function(obj) {
          var str = [];
          for(var p in obj)
            str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
          return str.join("&");
        },
        data: guest
      }).success(function(data, status, headers, config) {
        console.log('success');
      })
      .error(function(data, status, headers, config) {
        console.log("error", status);
      });

      $scope.view = 1;
    };

    $scope.deleteGuest = function(guest) {
      var response = confirm("Are you sure you want to delete " + guest.first_name + " " + guest.last_name);
      if (response == true) {
        console.log("delete");
        $http.delete('guests/' + guest.id)
          .success(function(data, status, headers, config) {
            console.log('success');
          })
          .error(function(data, status, headers, config) {
            console.log("error", status);
          });
      }
      $scope.view = 1;
    };

    $scope.isInGroup = function (guest, groupName) {
      return guest && guest.group && guest.group.some(function(el) {
        return el.name === groupName;
      });
    };

    $scope.isShowing = function (currentView) {
      return $scope.view === currentView
    };

    $scope.show = function (newView) {
      $scope.view = newView;
    };
  }]);

})();
