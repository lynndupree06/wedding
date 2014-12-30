(function () {

  var app = angular.module('guestApp', ['ngRoute', 'ngResource']);

  app.config(["$httpProvider", function (provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  }]);

  app.factory('Parties', ['$resource', function ($resource) {
    return $resource('/parties.json', {}, {
      query: { method: 'GET', isArray: true },
      create: { method: 'POST' }
    })
  }]);

  app.factory('Guests', ['$resource', function ($resource) {
    return $resource('/guests.json', {}, {
      query: { method: 'GET', isArray: true },
      create: { method: 'POST' }
    })
  }]);

  app.factory('Guest', ['$resource', function ($resource) {
    return $resource('/guests/:id.json', {}, {
      show: { method: 'GET' },
      update: { method: 'PUT', params: {id: '@id'} },
      delete: { method: 'DELETE', params: {id: '@id'} }
    });
  }]);

  app.config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
    $routeProvider.when('/guests', {
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

  app.controller('GuestController', ["$filter", "$scope", "$http", "Guests", "Guest", "Parties",
    function ($filter, $scope, $http, Guests, Guest, Parties) {
    $scope.view = 1;
    $scope.guests = [];
    $scope.orderByField = 'last_name';
    $scope.reverseSort = false;
    $scope.group = 'All';
    $scope.guests = Guests.query();
    $scope.groups = [
      {name: "Bride's Family", selected: false},
      {name: "Bride's Friends", selected: false},
      {name: "Groom's Family", selected: false},
      {name: "Groom's Friends", selected: false},
      {name: "Bridal Party", selected: false},
      {name: "Rehearsal Dinner", selected: false},
      {name: "Sunday Brunch", selected: false}
    ];

    $scope.parties = Parties.query();

    $scope.editGuest = function (currentGuest) {
      $scope.guest = currentGuest;
      for (var j in $scope.guest.group) {
        for (var k in $scope.groups) {
          var groupOption = $scope.groups[k];
          var group = $scope.guest.group[j];

          if (groupOption.name == group.name) {
            groupOption.selected = true;
          } else {
            groupOption.selected = false;
          }
        }
      }
      $('#guestDetails').modal('show');
    };

    $scope.updateGuest = function (guest) {
      guest.updated_at = new Date();
      guest.group = $scope.groups;

      Guest.update(guest, function () {
        $scope.guests = Guests.query();
      }, function (error) {
        console.log("error", error);
      });

      $('#guestDetails').modal('hide');
    };

    $scope.deleteGuest = function (guest) {
      var response = confirm("Are you sure you want to delete " + guest.first_name + " " + guest.last_name);
      if (response == true) {
        Guest.delete({id: guest.id}, function () {
          $scope.guests = Guests.query();
        }, function (error) {
          console.log(error);
        });
      }
      $('#guestDetails').modal('hide');
    };
  }]);

  app.filter('filterList', function () {
    return function (guests, group) {
      guests = guests || [];
      var filtered = [];

      if (group === 'All') {
        filtered = guests;
      } else {
        angular.forEach(guests, function (guest) {
          for (var idx in guest.group) {
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
