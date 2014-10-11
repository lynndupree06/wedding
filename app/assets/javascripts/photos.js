$(function() {
  $("img.lazy").show().lazyload({
    effect : "fadeIn"
  });

  $('img.lazy').click(function () {
    $('#engagement-' + $(this).attr('id')).addClass('active');
    $('#myModal').modal('show');
  });

  $('.carousel').carousel({
    interval: false
  });
});