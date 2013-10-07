require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login successfully" do
    dan = users(:dan)

    post :create, username: dan.username, password: 'foo' # correct password

    assert_redirected_to user_path dan
    assert_equal dan.id, session[:user_id]
  end

  test "should fail to login" do
    dan = users(:dan)

    post :create, username: dan.username, password: 'wrong_password'

    assert_redirected_to sessions_new_path
  end

  test 'should logout' do
    get :destroy

    assert_redirected_to sessions_new_path
  end
end
