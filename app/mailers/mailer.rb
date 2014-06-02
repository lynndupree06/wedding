
#
# SendGrid Ruby Example (Mail Gem)
#
# This example shows how to send email through SendGrid
# using Ruby and the Mail gem.  For more information
# on the Mail gem, visit:
#
#     https://github.com/mikel/mail
#
# To use this example, you'll have to have the Mail
# gem installed. To install it, run the following:
#
#     gem install mail -v 2.5.3
#
# For the SMTP API, you will also need the json gem.
# To install, run the folloowing:
#
#     gem install json
#
# There is a known issue witih version 2.5.4 and SSL
# (https://github.com/mikel/mail/issues/548). If you
# have version 2.5.4 installed, you can uninstall it
# by running "gem uninstall mail -v 2.5.4" and then
# install version 2.5.3 with the command above.

require "rubygems"
require "mail"
require "json"

# CREDENTIALS
# Fill in the variables below with your SendGrid
# username and password.
# ====================================================

sg_username = "app25518661@heroku.com"
sg_password = "D3fuqwy7dt"


# MAIL INFORMAION
# Fill in the following variables with the relevant
# information
# ====================================================

# Your domain
domain = "knology.net"

# From Email Address
from_address = "jbrazelton@knology.net"

# To Email Address
to_address = "lynndupree06@gmail.com"

# Subject
subject = "This is a Test"

# Text Body
text = "Hello,\n\nThis is a test message from SendGrid.    We have sent this to you because you requested a test message be sent from your account.\n\nThis is a link to google.com: http://www.google.com\nThis is a link to apple.com: http://www.apple.com\nThis is a link to sendgrid.com: http://www.sendgrid.com\n\nThank you for reading this test message.\n\nLove,\nYour friends at SendGrid"

# HTML Body
html = "<table style=\"border: solid 1px #000; background-color: #666; font-family: verdana, tahoma, sans-serif; color: #fff;\"> <tr> <td> <h2>Hello,</h2> <p>This is a test message from SendGrid.    We have sent this to you because you requested a test message be sent from your account.</p> <a href=\"http://www.google.com\" target=\"_blank\">This is a link to google.com</a> <p> <a href=\"http://www.apple.com\" target=\"_blank\">This is a link to apple.com</a> <p> <a href=\"http://www.sendgrid.com\" target=\"_blank\">This is a link to sendgrid.com</a> </p> <p>Thank you for reading this test message.</p> Love,<br/> Your friends at SendGrid</p> <p> <img src=\"http://cdn1.sendgrid.com/images/sendgrid-logo.png\" alt=\"SendGrid!\" /> </td> </tr> </table>"


# SEND THE MAIL
# ====================================================

begin
  Mail.defaults do
    delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                             :port      => 587,
                             :domain    => domain,
                             :user_name => sg_username,
                             :password  => sg_password,
                             :authentication => "plain",
                             :enable_starttls_auto => true }
  end
  mail = Mail.new do
    to to_address
    from from_address
    subject subject
    text_part do
      body text
    end
    html_part do
      content_type "text/html; charset=UTF-8"
      body html
    end
  end

  # Add the SMTP API Header
  smtpapi = {
  }
  mail.header["X-SMTPAPI"] = smtpapi.to_json

  mail.deliver
  puts "Email sent successfully."
rescue Exception => e
  puts e.message
end