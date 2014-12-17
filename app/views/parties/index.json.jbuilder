json.array!(@parties) do |party|
  json.extract! party, :id, :name, :outer_envelop, :inner_envelop, :created_at, :updated_at, :address, :city, :state, :postal_code, :country, :email, :a_b_list, :rsvp, :size, :save_the_date_sent, :notes, :key, :confirmed, :rsvp_dinner, :rsvp_brunch, :size_rehearsal, :size_brunch, :guests
  json.url party_url(party, format: :json)
end
