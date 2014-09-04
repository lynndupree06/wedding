function setup_rsvp(partySizeInput, detailsPanel, $mealDiv, $partyDiv) {
  var div = $mealDiv.first().clone();
  var idCodeFormGroup = $('input#id_code').parent().parent();
  var guests;

  function guest_meal_preferences() {
      var idCode =  $('#id_code').val();

      $.get('/party_guests/' + idCode, function (data) {
          guests = data.guests;

          if (guests) {
              idCodeFormGroup.attr('class', 'form-group has-success');
          } else {
              idCodeFormGroup.attr('class', 'form-group has-error');
              detailsPanel.hide();
          }
      }).fail(function () {
          idCodeFormGroup.attr('class', 'form-group has-error');
          detailsPanel.hide();
      });
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
          var span = "<span>(<a class='not-correct'>not correct?</a>)</span>";
          $mealDiv.remove();
          for (var i = num - 1; i >= 0; i--) {
              var newDiv = div.clone();

              if (guests[i]) {
                  var guest = guests[i];
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  newDiv.find('label').html(guest.first_name + ' ' + guest.last_name + ' ' + span);
                  newDiv.insertAfter($partyDiv);
                  // newDiv.show();
              } else {
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  newDiv.find('label').html('Guest ' + i + ' ' + span);
                  newDiv.insertAfter($partyDiv);
                  // newDiv.show();
              }
          }
      }
  });

  $('input#id_code').keyup(function() {
    guest_meal_preferences();
  });

  $('.not-correct').click(function(){
    // $(this).parent().parent().replaceWith( function() {
    //     return "<input type=\"text\" value=\"" + $(this).html() + "\" />";
    // });
  });
}
