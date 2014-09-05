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
          var span1 = "<span>(<a class='not-correct'>not correct?</a>)</span>";
          var span2 = "<span>(<a class='not-correct'>change name</a>)</span>";
          $('.meal-preference').remove();
          for (var i = num-1; i >= 0; i--) {
              var newDiv = div.clone();

              if (guests[i]) {
                  var guest = guests[i];
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  newDiv.find('label').html(guest.first_name + ' ' + guest.last_name + ' ' + span1);
                  newDiv.insertAfter($partyDiv);
              } else {
                  newDiv.find('select').attr('name', 'meal[' + i + ']');
                  newDiv.find('select').attr('required', 'required');
                  newDiv.find('label').html('Guest ' + (i+1) + ' ' + span2);
                  newDiv.insertAfter($partyDiv);
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
