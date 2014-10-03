function showGuests(id) {
  $("guests-" + id).toggle();
}

$('.edit-party').click(function () {
  var id = $(this).attr('id');
  editParty(id);
});

function editParty(id) {
  var url = '/parties/' + id + '/edit';

  $.get(url, function (data) {
    $('.modal-body').html('');
    $('.modal-body').html(data.match(/<form(\r|\n|.)+<\/form>/g));
    $('#selected-record').modal('show');
  });
}

$('.show-party').click(function () {
  var id = $(this).attr('id');
  var url = '/parties/' + id;

  $.get(url, function (data) {
    $('.modal-body').html('');
    $('.modal-body').html(data.match(/<h1>(\r|\n|.)+<\/ul>\n<\/p>/g));
    $('#selected-record').modal('show');
  });
});