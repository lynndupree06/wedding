(function () {

  var app = angular.module('admin', ['ngResource']);

  app.config(["$httpProvider", function (provider) {
    provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
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

  app.controller('PartyController', ["$scope", "$http", "Parties", "Party", "Guest", "Guests",
    function ($scope, $http, Parties, Party, Guest, Guests) {
    $scope.view = 1;
    $scope.orderByField = 'name';
    $scope.reverseSort = false;
    $scope.list = 'All';
    $scope.addingNew = false;

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
          $scope.addingNew = true;
      } else {
        $scope.party = currentParty;
      }
      $('#partyDetails').modal('show');
    };

    $scope.update = function(party) {
      var self = this;

      if($scope.addingNew) {
        Parties.create(party, function() {
          $scope.parties = Parties.query();
          $scope.addingNew = false;
        }, function (error) {
          console.log(error);
        });
      } else {
        Party.update(party, function() {
          // self.loadList();
        }, function (error) {
          console.log(error);
        });
      }

      $('#partyDetails').modal('hide');
    };

    $scope.delete = function (partyId) {
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

    $scope.next = function (currentParty) {
      var idx = $scope.parties.indexOf(currentParty);
      if(idx < $scope.parties.length - 1) {
        $scope.party = $scope.parties[idx + 1];
      } else {
        $scope.party = $scope.parties[0];
      }
    };

    $scope.previous = function (currentParty) {
      var idx = $scope.parties.indexOf(currentParty);
      if(idx > 0) {
        $scope.party = $scope.parties[idx - 1];
      } else {
        $scope.party = $scope.parties[$scope.parties.length - 1];
      }
    };

    $scope.addNewGuestOptions = function () {
      $scope.addingNew = true;
      $scope.newGuest = {};
    };

    $scope.addExistingGuestOptions = function () {
      $scope.guests = Guests.query();
      $scope.addingExisting = true;
    };

    $scope.addNewGuest = function (party) {
      if(party.id !== undefined) {
        $scope.newGuest.party = { id: party.id };

        Guests.create($scope.newGuest, function(data) {
          console.log('success');
          $scope.newGuest.id = data.id;
          party.guests[party.guests.length] = $scope.newGuest;
          $scope.addingNew = false;
          $scope.newGuest = {};
        }, function (error) {
          console.log(error);
        });
      } else {
        if(party.guests === undefined) {
          party.guests = [];
          party.guests[0] = $scope.newGuest;
        } else {
          party.guests[party.guests.length] = $scope.newGuest;
        }
      }
    };

    $scope.addExistingGuest = function (party) {
      var existingGuest = JSON.parse($scope.newExistingGuest);
      
      if(party.id !== undefined) {
        existingGuest.party = { id: party.id };

        Guest.update(existingGuest, function() {
          console.log('success');
          party.guests[party.guests.length] = existingGuest;
          $scope.addingExisting = false;
        }, function (error) {
          console.log(error);
        });
      } else {
        if(party.guests === undefined) {
          party.guests = [];
          party.guests[0] = exisitingGuest;
        } else {
          party.guests[party.guests.length] = exisitingGuest;
        }
      }
    };

    $scope.removeGuestFromParty = function (party, guest) {
      Guest.delete({id: guest.id}, function() {
        console.log('success');
        var idx = party.guests.indexOf(guest);
        party.guests.splice(idx, 1);
      }, function (error) {
        console.log(error);
      })
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
