class Emailer < ActionMailer::Base

  def send_notification_of_rsvp_email(party)
    @party = party
    mail(:to => 'lynndupree06+wedding@gmail.com',
         :subject => "#{party.name} RSVP'd")
  end
end