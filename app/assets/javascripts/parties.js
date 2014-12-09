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

  var app = angular.module('admin', []);

  app.controller('StatusController', function () {
    this.isMissingEmail = function(party) {
      return party.email === null || party.email.length === 0;
    };

    this.isMissingAddress = function(party) {
      return party.address === null || party.address.length === 0;
    };
  });

  app.controller('PartyController', function ($scope, $http) {
    $http.get('parties_info')
      .success(function(data, status, headers, config) {
        $scope.parties = data;
      })
      .error(function(data, status, headers, config) {
        console.log("error", status);
      });

    this.isFemale = function(guest) {
      return guest.gender === 'Female';
    };

    this.isMale = function(guest) {
      return guest.gender === 'Male';
    };
  });

})();
