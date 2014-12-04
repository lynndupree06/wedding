function setupPhotoDisplay(engagement_size, party_size) {

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

  function setModalTitle(id, category) {
    if(category === 'engagement') {
      $('.modal-title').html('Engagement Photos: ' + id + ' of ' + engagement_size);
    } else if (category === 'party') {
      $('.modal-title').html('Engagement Party Photos: ' + id + ' of ' + party_size);
    }
  }

  $('.carousel-control').click(function () {
    var right = $(this).attr('class').indexOf('right') >= 0;
    var id = $(this).parent().find('.active').attr('id');
    var imageDetails = id.split('-');
    var idNumber = Number(imageDetails[1]) + 1;
    var type = imageDetails[0];

    idNumber = right ? idNumber + 1 : idNumber - 1;

    switch (idNumber) {
      case 0:
        if(type === 'engagement') {
          idNumber = party_size;
          type = 'party';
        } else if(type === 'party') {
          idNumber = engagement_size;
          type = 'engagement';
        }
        break;
      case (engagement_size + 1):
        if(type === 'engagement') {
          idNumber = 1;
          type = 'party';
        }
        break;
      case (party_size + 1):
        idNumber = 1;
        type = 'engagement';
        break;
    }

    setModalTitle(idNumber);
  });

  $('.tabs a').click(function () {
    $('.tabs a').removeClass('active');
    $(this).addClass('active');
  });
}