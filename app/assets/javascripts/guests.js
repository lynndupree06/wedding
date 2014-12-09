var $modalBody = $('.modal-body');

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

  app.controller('GuestController', ["$scope", "$http", function ($scope, $http) {
    $http.get('guests_info')
      .success(function(data, status, headers, config) {
        $scope.guests = data;
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
  }]);

})();