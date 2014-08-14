class PartyNotifier < ActionMailer::Base
  default from: 'jbrazelton@knology.net'

  def send_save_the_date_email(party)
    unless party.save_the_date_sent
    @party = party
    @token = PartyEncoder.encode(@party.id)
    mail( :to => party.email,
          :subject => 'Save the Date! June 6, 2015' )
    end
  end
end
