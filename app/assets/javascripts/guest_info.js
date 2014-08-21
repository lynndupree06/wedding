function setupGuestInfo(collapseElements) {

  $('.collapse').collapse({
    parent: true
  });

  function toggleCollapse(panel) {
    if ($(panel).attr('class').contains('in')) {

    } else {
    }
  }

  $('.collapse').on('show.bs.collapse', function () {
    toggleCollapse($('#travel'));
    toggleCollapse($('#accommodation'));
    toggleCollapse($('#locations'));
  });
}