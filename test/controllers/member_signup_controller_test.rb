require 'test_helper'

class MemberSignupControllerTest < ActionController::TestCase
  setup do
    @new_member = {
      username: "Nightblade6",
      password: "oren",
      password_confirmation: "oren",
      first_name: "Oren",
      last_name: "Reinstein"
    }
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new member" do
    assert_difference('User.count') do
      post :create, controller: :member_signup, user: @new_member
    end
    
    assert_redirected_to user_path(assigns(:user))
  end

end
