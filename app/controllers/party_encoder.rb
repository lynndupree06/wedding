require 'rubygems'
require 'rqrcode'

class PartyEncoder
  def self.encode(party_id)
    Base64.urlsafe_encode64("party_id=#{party_id}")
  end

  def self.decode(token)
    Base64.urlsafe_decode64(token)
  end

  def self.get_qr_code(id_code)
    RQRCode::QRCode.new("http://www.jessica-and-fred.com/rsvp?code=#{id_code}", :size => 6, :level => :h )
  end
end
