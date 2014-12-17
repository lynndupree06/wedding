json.array!(@guests) do |guest|
  json.extract! guest, :id, :last_name, :first_name, :title, :suffix, :party_id, :gender, :child, :meal_option, :table
  json.url guest_url(guest, format: :json)
end
