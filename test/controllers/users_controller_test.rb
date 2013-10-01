require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @new_user = {
        password: 'password',
        password_confirmation: 'password',
        first_name: 'Oren',
        last_name: 'Reinstein',
        user_type_id: UserType.find_by_name('member')
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
          first_name: @new_user[:first_name],
          last_name: @new_user[:last_name],
          password: @new_user[:password],
          password_confirmation: @new_user[:password],
          user_type_id: @new_user[:user_type_id]
      }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: users(:dan)
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: users(:dan)
    assert_response :success
  end

  test "should update user with new password" do
    new_password = 'new_password123'

    patch :update, id: users(:dan), user: {
        password: new_password,
        password_confirmation: new_password
    }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: users(:dan)
    end

    assert_redirected_to users_path
  end
end
