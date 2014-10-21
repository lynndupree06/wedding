$(function () {
  $("img.lazy").show().lazyload({
    effect: "fadeIn"
  });

  $('img.lazy').click(function () {
    var id = $(this).attr('id');
    $('.item').removeClass('active');
    $('#engagement-' + id).addClass('active');
    $('#myModal').modal('show');
    setModalTitle(Number(id) + 1);
  });

  $('.carousel').carousel({
    interval: false
  });

  function setModalTitle(id) {
    $('.modal-title').html('Engagement Photos: ' + id + ' of 17');
  }

  $('.carousel-control').click(function () {
    var right = $(this).attr('class').indexOf('right') >= 0;
    var id = $(this).parent().find('.active').attr('id');
    var idNumber = Number(id.substr(id.indexOf('-') + 1)) + 1;

    idNumber = right ? idNumber + 1 : idNumber - 1;

    switch (idNumber) {
      case 0: idNumber = 17; break;
      case 18: idNumber = 1; break;
    }

    setModalTitle(idNumber);
  });

  $('.tabs a').click(function () {
    $('.tabs a').removeClass('active');
    $(this).addClass('active');
  });
});