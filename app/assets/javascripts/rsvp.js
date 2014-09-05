function setup_rsvp(partySizeInput, detailsPanel, $mealDiv, $partyDiv) {
  var div = $mealDiv.first().clone();
  var idCodeFormGroup = $('input#id_code').parent().parent();
  var guests;

  function guest_meal_preferences() {
      var idCode =  $('#id_code').val();

      $.get('/party_guests/' + idCode, function (data) {
          guests = data.guests;

          if (guests) {
              idCodeFormGroup.attr('class', 'form-group has-success has-feedback');
              if(idCodeFormGroup.find('span')) {
                idCodeFormGroup.find('span').remove();
              }
              idCodeFormGroup.find('input').after('<span class="glyphicon glyphicon-ok form-control-feedback"></span>')
          } else {
              displayIncorrectCode(idCodeFormGroup, detailsPanel);
          }
      }).fail(function () {
          displayIncorrectCode(idCodeFormGroup, detailsPanel);
      });
  }

  function displayIncorrectCode(idCodeFormGroup, detailsPanel) {
    idCodeFormGroup.attr('class', 'form-group has-error has-feedback');
    if(idCodeFormGroup.find('span')) {
      idCodeFormGroup.find('span').remove();
    }
    idCodeFormGroup.find('input').after('<span class="glyphicon glyphicon-remove form-control-feedback"></span>');
    detailsPanel.hide();
  }

  $("input[type='radio']").click(function () {
      if ($(this).attr('id') == 'no') {
          partySizeInput.removeAttr('required');
          $('.meal').removeAttr('required');
          detailsPanel.hide();
      } else {
          partySizeInput.attr('required', 'required');
          $('.meal').attr('required', 'required');
          var idCodeClasses = idCodeFormGroup.attr('class');

          if (partySizeInput.val() && !idCodeClasses.contains('has-error')) {
              detailsPanel.show();
          }
      }
  });

  partySizeInput.change(function () {
      if ($('input#id_code').val()) {
          detailsPanel.show();

          var num = Number($(this).val());
          $('.meal-preference').remove();
          for (var i = num-1; i >= 0; i--) {
              var newDiv = div.clone();

              if (guests[i]) {
                  var guest = guests[i];
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  var span = "<span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>not correct?</a>)</span>";
                  newDiv.find('label').html(guest.first_name + ' ' + guest.last_name + ' ' + span);
                  newDiv.insertAfter($partyDiv);
              } else {
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  var span = "<span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>change name</a>)</span>";
                  newDiv.find('label').html('Guest ' + (i+1) + ' ' + span);
                  newDiv.insertAfter($partyDiv);
              }
          }
      }
  });

  $('input#id_code').keyup(function() {
    guest_meal_preferences();
  });
}

function changeLabel(span) {
  $(span).parent().parent().replaceWith( function() {
    return "<input name='guest[" + $(span).attr('id') + "]' class='control-label col-sm-offset-2 col-sm-3' type='text' value='" + $(this).html().match(/(.*)\s<span>/)[1] + "' />";
  });
}
