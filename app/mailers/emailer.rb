class Emailer < ActionMailer::Base
  default from: 'jbrazelton@knology.net'

  def send_notification_of_rsvp_email(party)
    @party = party
    mail(:to => 'lynndupree06+wedding@gmail.com',
         :subject => "#{party.name} #{party.rsvp ? 'is Attending!' : 'is not Attending'}")
  end
end
