var $modal = $('.modal-body');

function showGuests(id) {
  $(".guests-" + id).toggle();
}

$('.edit-party').click(function () {
  var id = $(this).attr('id');
  editParty(id);
});

$('.edit-guest').click(function () {
  var id = $(this).attr('id');
  editGuest(id);
});

function editParty(id) {
  getRecord('/parties/' + id + '/edit', /<form(\r|\n|.)+<\/form>/g);
}

function editGuest(id) {
  getRecord('/guests/' + id + '/edit', /<form(\r|\n|.)+<\/form>/g);
}

function getRecord(url, regex) {
  $.get(url, function (data) {
    $modal.html('');
    $modal.html(data.match(regex));
    $('#selected-record').modal('show');
  });
}