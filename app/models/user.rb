class User < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # username: nvarchar(255), not null
  # user_type_id: foreign key, not null
  # password_digest: nvarchar(255), not null
  # first_name: nvarchar(255), not null, default: ""
  # last_name: nvarchar(255), not null, default: ""
  # created_at
  # updated_at

  has_secure_password

  belongs_to :user_type
  has_one :member, :class_name => 'UserTypes::Member'

  has_many :photos

  validates_presence_of :id, on: :update
  validates_presence_of :username, :first_name, :last_name, :user_type_id

  #before_validation :init
  #before_validation :must_belong_to_user_type

  def user_type_id=(value)
    self[:user_type_id] = value

    type = UserType.where(id: value).first
    set_user_type_relation(type.name)
  end

  def user_type=(value)
    self[:user_type_id] = value.to_param

    set_user_type_relation(value.name)
  end

  def sub_user
    case user_type.name
      when 'member'
        return self.member
    end
  end

  private

  def init
    self.first_name ||= 'noname'
    self.last_name ||= 'noname'
  end

  #def user_type=(value)
  #  self[:user_type] = value
  #  if user_type_class.where(user_id: self.id).empty?
  #    user_type_class.new(user_id: self.id)
  #  end
  #end

  def must_belong_to_user_type
    if user_type_class.where(user_id: self.id).empty?
      errors.add(:base, "User Type object not created: #{user_type_class.to_s}")
      return false
    end

    return true
  end

  def user_type_class
    "UserTypes::#{self.user_type.name.camelize}"
  end

  def set_user_type_relation(user_type_name)
    destroy_user_type_relation

    case user_type_name
      when 'member'
        self.member = UserTypes::Member.new
      else
        raise "value: #{user_type_name}, does not exist"
    end
  end

  def destroy_user_type_relation
    self.sub_user.destroy if self.sub_user != nil
  end
end
