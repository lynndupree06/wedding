json.array!(@photos) do |photo|
  json.extract! photo, :id, :desc, :category
  json.url photo_url(photo, format: :json)
end
