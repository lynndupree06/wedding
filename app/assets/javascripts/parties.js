var $modalBody = $('.modal-body');

function showGuests(id) {
  $(".guests-" + id).toggle();
}

$('.edit-party').click(function () {
  var id = $(this).attr('id');
  editParty(id);
});

function editParty(id) {
  getRecord('/parties/' + id + '/edit', /<form(\r|\n|.)+<\/form>/g);
}

function getRecord(url, regex) {
  $.get(url, function (data) {
    $modalBody.html('');
    $modalBody.html(data.match(regex));
    $('#selected-record').modal('show');
  });
}

$('.edit-guest').click(function () {
  var id = $(this).attr('id');
  editGuest(id);
});

function editGuest(id) {
  getRecord('/guests/' + id + '/edit', /<form(\r|\n|.)+<\/form>/g);
}

function getRecord(url, regex) {
  $.get(url, function (data) {
    $modalBody.html('');
    $modalBody.html(data.match(regex));
    $('#selected-record').modal('show');
  });
}

(function () {

  var app = angular.module('admin', ['ngResource']);

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

    this.loadList = function() {
      $scope.parties = Parties.query();
    };

    this.isFemale = function(guest) {
      return guest.gender === 'Female';
    };

    this.isMale = function(guest) {
      return guest.gender === 'Male';
    };

    $scope.editParty = function (currentParty) {
      $scope.view = 2;
      $scope.party = currentParty;
    };

    $scope.updateParty = function(currentParty) {
      var self = this;

      Party.update(currentParty, function() {
        self.loadList();
        $scope.view = 1;
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
    };

    $scope.isShowing = function (currentView) {
      return $scope.view === currentView
    };

    $scope.show = function (newView) {
      $scope.view = newView;
    };
  }]);

})();
