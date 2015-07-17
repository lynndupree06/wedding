class PartyNotifier < ActionMailer::Base
  default from: 'jbrazelton@knology.net'

  def send_save_the_date_email(party)
    unless party.save_the_date_sent
      @party = party
      @token = PartyEncoder.encode(@party.id)
      mail(:to => party.email,
           :subject => 'Save the Date! July 25, 2015')
      party.save_the_date_sent = true
      party.save!
    end
  end

  def send_reminder_email(party) 
    if party.address.blank? && party.save_the_date_sent
      @party = party
      @token = PartyEncoder.encode(@party.id)
      mail(:to => party.email,
           :subject => 'We need your address!')
      party.save!
    end
  end

  def send_rehearsal_invite(party)
    mail(:to => party.email,
          :subject => 'You are invited to our Rehearsal Dinner!')
  end
end
