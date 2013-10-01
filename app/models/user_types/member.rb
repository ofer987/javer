class UserTypes::Member < ActiveRecord::Base
  # id: Primary key, not null, auto increment
  # description: text, not null, default: ""
  # created_at
  # updated_at

  belongs_to :user
end
