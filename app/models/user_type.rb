class UserType < ActiveRecord::Base
  # id: Primary key, not null, auto increment
  # name: nvarchar(255), not null, default: ""
  # created_at
  # updated_at

  include Lookupable
end