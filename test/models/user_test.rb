require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'All member users should have a member model' do
    new_user = User.new do |user|
      user.first_name = 'Dennis'
      user.last_name = 'Hurricane'
      user.user_type_id = user_types(:member).id
      user.password = 'password'
      user.password_confirmation = 'password'
    end

    assert new_user.valid?, new_user.errors.to_a
  end

  test 'New member user has matching UserTypes::Member object' do
    new_user = User.new do |user|
      user.first_name = 'Dennis'
      user.last_name = 'Hurricane'
      user.password = 'password'
      user.password_confirmation = 'password'
    end

    assert new_user.member == nil

    # Set the user_type = UserTypes::Member.new
    new_user.user_type = user_types(:member)
    assert new_user.member != nil, 'Instance of UserTypes::Member object was not created'

    assert new_user.valid?, 'The user is not valid'

    # Before saving
    assert new_user.member.user_id == nil, 'The member.user_id should be nil because member was not saved yet'
    assert new_user.member.id == nil, 'The member.id should be nil because member was not saved yet'

    # Saving the user should also save the related user_type object
    assert new_user.save, 'Error saving the user'
    assert new_user.id != nil, 'The user.id was not set when saving'
    assert new_user.member.user_id != nil, 'The member.user_id was not set when saving'
    assert new_user.member.id != nil, 'The member.id was not set when saving'
  end
end
