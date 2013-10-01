json.array!(@photos) do |photo|
  json.extract! photo, :user_id, :title, :description, :filename, :taken_at
  json.url photo_url(photo, format: :json)
end
