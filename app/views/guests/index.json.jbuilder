json.array!(@guests) do |guest|
  json.extract! guest, :id, :last_name, :first_name, :address1, :address2, :city, :state, :postal_code, :country, :email
  json.url guest_url(guest, format: :json)
end
