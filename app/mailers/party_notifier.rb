class PartyNotifier < ActionMailer::Base
  default from: 'jbrazelton@knology.net'

  def send_save_the_date_email(party)
    @party = party
    @token = PartyEncoder.encode(@party.id)
    mail( :to => party.email,
          :subject => 'Save the Date! May 16, 2015' )
  end
end
