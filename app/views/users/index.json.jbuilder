json.array!(@users) do |user|
  json.extract! user, :user_type_id, :password_digest, :first_name, :last_name
  json.url user_url(user, format: :json)
end
