class Photosize < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # name: nvarchar(255), not null
  # created_at
  # updated_at

  include Lookupable

  has_many :fichiers
end
