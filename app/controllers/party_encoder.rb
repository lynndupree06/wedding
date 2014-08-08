class PartyEncoder
  def self.encode(party_id)
    Base64.urlsafe_encode64("party_id=#{party_id}")
  end

  def self.decode(token)
    Base64.urlsafe_decode64(token)
  end
end