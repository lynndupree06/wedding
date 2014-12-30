(function () {

  var app = angular.module('admin', ['ngResource']);

  app.config(["$httpProvider", function (provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  }]);

  app.factory('Parties', ['$resource', function ($resource) {
    return $resource('/parties.json', {}, {
      query: { method: 'GET', isArray: true },
      create: { method: 'POST' }
    })
  }]);

  app.factory('Party', ['$resource', function ($resource) {
    return $resource('/parties/:id.json', {}, {
      show: { method: 'GET' },
      update: { method: 'PUT', params: {id: '@id'} },
      delete: { method: 'DELETE', params: {id: '@id'} }
    });
  }]);

  app.controller('StatusController', function () {
    this.isMissingEmail = function(party) {
      return party.email === null || party.email.length === 0;
    };

    this.isMissingAddress = function(party) {
      return party.address === null || party.address.length === 0;
    };
  });

  app.controller('PartyController', ["$scope", "$http", "Parties", "Party", function ($scope, $http, Parties, Party) {
    $scope.view = 1;
    $scope.orderByField = 'name';
    $scope.reverseSort = false;
    $scope.list = 'All';

    $scope.loadList = function() {
      $scope.parties = Parties.query();
    };

    this.isFemale = function(guest) {
      return guest.gender === 'Female';
    };

    this.isMale = function(guest) {
      return guest.gender === 'Male';
    };

    $scope.editParty = function (currentParty) {
      if(currentParty === undefined) {
          $scope.party = {};
      } else {
        $scope.party = currentParty;
      }
      $('#partyDetails').modal('show');
    };

    $scope.updateParty = function(party) {
      var self = this;
      $('#partyDetails').modal('hide');

      Party.update(party, function() {
        self.loadList();
      }, function (error) {
        console.log(error);
      });
    };

    $scope.deleteParty = function (partyId) {
      var self = this;

      if (confirm("Are you sure you want to delete this party?")) {
        Party.delete({id: partyId}, function() {
          self.loadList();
          $scope.view = 1;
        }, function (error) {
          console.log(error);
        });
      }
      $('#partyDetails').modal('hide');
    };

    $scope.isShowing = function (currentView) {
      return $scope.view === currentView
    };

    $scope.show = function (newView) {
      $scope.view = newView;
    };
  }]);

  app.filter('filterList', function() {
    return function(parties, list) {
      parties = parties || [];
      var filtered = [];

      if (list === 'All') {
        filtered = parties;
      } else {
        angular.forEach(parties, function(party) {
          if(party.a_b_list === list) {
            filtered.push(party);
          }
        });
      }

      return filtered;
    };
  })

})();
