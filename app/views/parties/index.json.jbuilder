json.array!(@parties) do |party|
  json.extract! party, :id, :name, :outer_envelop, :inner_envelop
  json.url party_url(party, format: :json)
end
