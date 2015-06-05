function setup_rsvp(partySizeInput, detailsPanel, $mealDiv, $partyDiv) {
    var div = $mealDiv.first().clone();
    var idCodeFormGroup = $('input#id_code').parent().parent();
    var guests;

    function askAdditionalQuestions(rehearsal, brunch) {
        if (rehearsal) {
            $('.rehearsal').show();
            $('.rehearsal').find('input#yes-rehearsal').attr('required', 'required');
        } else {
            $('.rehearsal').hide();
        }

        if (brunch) {
            $('.brunch').show();
            $('.brunch').find('input#yes-brunch').attr('required', 'required');
        } else {
            $('.brunch').hide();
        }

    }

    function getPartyAndGuests(party_id) {
        $('#rsvp_party').val(party_id);
        $('.rsvp-party-label').html($('.rsvp_party option:selected').html());
        $('.rsvp-party-label').removeClass('hidden');

        $.get('/party_guests/' + party_id, function (data) {

            guests = data.guests;
            askAdditionalQuestions(data.rehearsal, data.brunch);

            if (checkValidility()) {
                createGuestMeals();
            }
        });
    }

    function removePartyAndGuests() {
        $('.rsvp_party_input').addClass('hidden');
        $('.rsvp-party-label').addClass('hidden');
        detailsPanel.addClass('hidden');
        $('.rehearsal').hide();
        $('.brunch').hide();
    }

    function guest_meal_preferences() {
        var idCode = $('#id_code').val().toUpperCase();

        $.get('/get_parties/' + idCode, function (data) {
            parties = data.parties;

            if (parties) {

                $("#rsvp_party_input").autocomplete({
                    source: parties,

                    select: function (event, ui) {
                        if (!ui.item) {
                            this.value = '';
                            removePartyAndGuests();
                        } else {
                            getPartyAndGuests(ui.item.party_id);
                        }

                        return false;
                    },

                    select: function (event, ui) {
                        $(this).val(ui.item ? ui.item : " ");

                        if (!ui.item) {
                            this.value = '';
                            removePartyAndGuests();
                        } else {
                            getPartyAndGuests(ui.item.party_id);
                        }
                    },

                    change: function (event, ui) {
                        if (!ui.item) {
                            this.value = '';
                            removePartyAndGuests();
                        } else {
                            getPartyAndGuests(ui.item.party_id);
                        }
                    }
                });

                idCodeFormGroup.attr('class', 'form-group has-success has-feedback');
                idCodeFormGroup.attr('data-valid', 'valid');
                if (idCodeFormGroup.find('span')) {
                    idCodeFormGroup.find('span').remove();
                }

                $('.rsvp_guest').removeClass('hidden');
            } else {
                displayIncorrectCode();
                removePartyAndGuests();
            }
        }).fail(function () {
            displayIncorrectCode();
            removePartyAndGuests();
        });
    }

    function displayIncorrectCode() {
        idCodeFormGroup.attr('class', 'form-group has-error has-feedback');
        idCodeFormGroup.attr('data-valid', 'invalid');
        if (idCodeFormGroup.find('span')) {
            idCodeFormGroup.find('span').remove();
        }
        detailsPanel.addClass('hidden');
    }

    function checkValidility() {
        return partySizeInput.val() > 0 && idCodeFormGroup.attr('data-valid') == 'valid' && $("input[type='radio']:checked").attr('id') == 'yes';
    }

    $("input[name='rsvp'][type='radio']").click(function () {
        if ($(this).attr('id') == 'no') {
            partySizeInput.removeAttr('required');
            $('.meal').removeAttr('required');
            detailsPanel.addClass('hidden');
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

    function showHideSizeInput(id, $sizeInputDiv, sizeInputId, conditions) {
        var no = conditions[0];
        var yes = conditions[1];

        if (id == no) {
            $sizeInputDiv.show();
            $sizeInputDiv.find(sizeInputId).attr('required', 'required');
        } else if (id == yes) {
            $sizeInputDiv.hide();
            $sizeInputDiv.find(sizeInputId).removeAttr('required');
        }
    }

    $("input[type='radio']").click(function () {
        var $sizeInput;
        var id;
        var name = $(this).attr('name');

        if (name == 'rsvp_rehearsal') {
            $sizeInput = $('#party-size-rehearsal');
            id = $(this).attr('id');
            showHideSizeInput(id, $sizeInput, '#party_rehearsal', ['no-rehearsal', 'yes-rehearsal']);
        } else if (name == 'rsvp_brunch') {
            $sizeInput = $('#party-size-brunch');
            id = $(this).attr('id');
            showHideSizeInput(id, $sizeInput, '#party_brunch', ['no-brunch', 'yes-brunch']);
        }
    });

    function createGuestMeals() {
        detailsPanel.removeClass('hidden');

        var num = Number(partySizeInput.val());
        $('.meal-preference').remove();
        for (var i = num - 1; i >= 0; i--) {
            var newDiv = div.clone();
            newDiv.find('select').attr('name', 'meal[' + i + ']');
            //newDiv.find('select').attr('required', 'required');

            if (guests[i]) {
                var guest = guests[i];
                var span = "<span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>not correct?</a>)</span>";
                newDiv.find('label').html(guest.first_name + ' ' + guest.last_name + ' ' + span);
                newDiv.insertAfter($partyDiv);
            } else {
                var span = "<span>(<a id='" + i + "' onclick='changeLabel(this)' class='not-correct'>change name</a>)</span>";
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

    if ($('input#id_code').val() !== '') {
        guest_meal_preferences();
    }

    $('input#id_code').keyup(function () {
        guest_meal_preferences();
    });

    $('.rsvp_party').change(function () {
        var party_id = $('.rsvp_party option:selected').val();

        $.get('/party_guests/' + party_id, function (data) {

            guests = data.guests;
            askAdditionalQuestions(data.rehearsal, data.brunch);

            if (checkValidility()) {
                createGuestMeals();
            }
        });
    });

}

function changeLabel(span) {
    $(span).parent().parent().replaceWith(function () {
        return "<input name='guest[" + $(span).attr('id') + "]' class='col-sm-6' type='text' value='" + $(this).html().match(/(.*)\s<span>/)[1] + "' />";
    });
}
