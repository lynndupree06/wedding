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
  app.controller('GuestController', ["$filter", "$scope", "$http", "ngTableParams", "Guests", "Guest", function ($filter, $scope, $http, ngTableParams, Guests, Guest) {
    $scope.view = 1;
    $scope.guests = [];
    $scope.orderByField = 'last_name';
    $scope.reverseSort = false;
    $scope.group = 'All';

    $scope.guests = Guests.query();

    // $http.get('guests_info')
    //   .success(function(data, status, headers, config) {
    //     $scope.guests = data;
    //     $scope.tableParams = new ngTableParams({
    //       page: 1,            // show first page
    //       total: data.length, // length of data
    //       count: 15          // count per page
    //     });
    //
    //     $scope.$watch('tableParams', function(params) {
    //       var orderedData = params.sorting ?
    //         $filter('orderBy')(data, params.orderBy()) :
    //         data;
    //
    //         $scope.guests = orderedData.slice((params.page - 1) * params.count, params.page * params.count);
    //     }, true);
    //   })
    //   .error(function(data, status, headers, config) {
    //     console.log("error", status);
    //   });

    $scope.editGuest = function(currentGuest) {
      $scope.view = 2;
      $scope.guest = currentGuest;
    };

    $scope.updateGuest = function(guest) {
      guest.updated_at = new Date();

      Guest.update(guest, function() {
        console.log('success');
        $scope.view = 1;
      }, function(error) {
        console.log("error", error);
      });
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

  app.filter('filterList', function() {
    return function(guests, group) {
      guests = guests || [];
      var filtered = [];

      if (group === 'All') {
        filtered = guests;
      } else {
        angular.forEach(guests, function(guest) {
          for(var idx in guest.group) {
            if (guest.group[idx].name === group) {
              filtered.push(guest);
              break;
            }
          }
        });
      }

      return filtered;
    };
  })

})();
