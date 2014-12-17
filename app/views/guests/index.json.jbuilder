json.array!(@guests) do |guest|
  json.extract! guest, :id, :last_name, :first_name, :title, :suffix, :party, :gender, :child, :meal_option, :table, :group
  json.url guest_url(guest, format: :json)
end
