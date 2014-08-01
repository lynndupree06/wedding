class GuestNotifier < ActionMailer::Base
  default from: 'jbrazelton@knology.net'

  def send_save_the_date_email(user)
    @user = user
    mail( :to => "lynndupree06+#{user.first_name}@gmail.com",
          :subject => 'Save the Date!' )
  end
end
