require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @new_photo = {
        description: 'This is a beautiful new photo',
        filename: 'beautiful.jpg',
        taken_at: DateTime.current, # UTC time
        title: "My mom's photo",
        user_id: users(:dan).to_param
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, photo: {
          description: @new_photo[:description],
          filename: @new_photo[:filename],
          taken_at: @new_photo[:taken_at],
          title: @new_photo[:title],
          user_id: @new_photo[:user_id]
      }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should show photo" do
    get :show, id: photos(:building)
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: photos(:building)
    assert_response :success
  end

  test "should update photo (title)" do
    new_title = 'This is the photo\'s newest title'

    patch :update, id: photos(:building),
          photo: {
              title: new_title
          }
    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete :destroy, id: photos(:building)
    end

    assert_redirected_to photos_path
  end
end
