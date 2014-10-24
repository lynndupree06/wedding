var $modalBody = $('.modal-body');

$('.guests').filterable();

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