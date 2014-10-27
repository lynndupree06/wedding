function setup_rsvp(partySizeInput, detailsPanel, $mealDiv, $partyDiv) {
  var div = $mealDiv.first().clone();
  var idCodeFormGroup = $('input#id_code').parent().parent();
  var guests;

  function askAdditionalQuestions(rehearsal, brunch) {
    if(rehearsal) {
      $('.rehearsal').show();
      $('.rehearsal').find('input#yes-rehearsal').attr('required', 'required');
    }

    if(brunch) {
      $('.brunch').show();
      $('.brunch').find('input#yes-brunch').attr('required', 'required');
    }

  }

  function guest_meal_preferences() {
    var idCode = $('#id_code').val();

    $.get('/party_guests/' + idCode, function (data) {
      guests = data.guests;

      if (guests) {
        idCodeFormGroup.attr('class', 'form-group has-success has-feedback');
        idCodeFormGroup.attr('data-valid', 'valid');
        if (idCodeFormGroup.find('span')) {
          idCodeFormGroup.find('span').remove();
        }
        idCodeFormGroup.find('input').after('<span class="glyphicon glyphicon-ok form-control-feedback"></span>');
        askAdditionalQuestions(data.rehearsal, data.brunch);

        if (checkValidility()) {
          createGuestMeals();
        }
      } else {
        displayIncorrectCode();
      }
    }).fail(function () {
      displayIncorrectCode();
    });
  }

  function displayIncorrectCode() {
    idCodeFormGroup.attr('class', 'form-group has-error has-feedback');
    idCodeFormGroup.attr('data-valid', 'invalid');
    if (idCodeFormGroup.find('span')) {
      idCodeFormGroup.find('span').remove();
    }
    idCodeFormGroup.find('input').after('<span class="glyphicon glyphicon-remove form-control-feedback"></span>');
    detailsPanel.hide();
  }

  function checkValidility() {
    return partySizeInput.val() > 0 && idCodeFormGroup.attr('data-valid') == 'valid' && $("input[type='radio']:checked").attr('id') == 'yes';
  }

  $("input[type='radio']").click(function () {
    if ($(this).attr('id') == 'no') {
      partySizeInput.removeAttr('required');
      $('.meal').removeAttr('required');
      detailsPanel.hide();
      $('.meal-preference').remove();
    } else {
      partySizeInput.attr('required', 'required');
      $('.meal').attr('required', 'required');
      var idCodeClasses = idCodeFormGroup.attr('class');

      if (checkValidility()) {
        createGuestMeals();
      }
    }
  });

  function createGuestMeals() {
    detailsPanel.show();

    var num = Number(partySizeInput.val());
    $('.meal-preference').remove();
    for (var i = num - 1; i >= 0; i--) {
      var newDiv = div.clone();

      if (guests[i]) {
        var guest = guests[i];
        newDiv.find('select').attr('name', 'meal[' + i + ']');
        newDiv.find('select').attr('required', 'required');
        var span = "<br><span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>not correct?</a>)</span>";
        newDiv.find('label').html(guest.first_name + ' ' + guest.last_name + ' ' + span);
        newDiv.insertAfter($partyDiv);
      } else {
        newDiv.find('select').attr('name', 'meal[' + i + ']');
        newDiv.find('select').attr('required', 'required');
        var span = "<br><span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>change name</a>)</span>";
        newDiv.find('label').html('Guest ' + (i + 1) + ' ' + span);
        newDiv.insertAfter($partyDiv);
      }
    }
  }

  partySizeInput.change(function () {
    if (checkValidility()) {
      createGuestMeals();
    }
  });

  $('input#id_code').keyup(function () {
    guest_meal_preferences();
  });
}

function changeLabel(span) {
  $(span).parent().parent().replaceWith(function () {
    return "<input name='guest[" + $(span).attr('id') + "]' class='control-label col-sm-offset-2 col-sm-3' type='text' value='" + $(this).html().match(/(.*)\s<span>/)[1] + "' />";
  });
}

