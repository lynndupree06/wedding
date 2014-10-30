json.array!(@tables) do |table|
  json.extract! table, :id, :number, :name
  json.url table_url(table, format: :json)
end
