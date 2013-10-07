require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  IMAGE_SOURCE_FOLDER = Rails.root.join('test', 'assets', 'images')

  setup do
    @photo = photos(:building)
    @user = @photo.user

    @new_photo = {
        description: 'This is a beautiful new photo',
        filename: 'beautiful.jpg',
        taken_at: DateTime.current, # UTC time
        name: "My mom's photo",
        user_id: users(:dan).to_param
    }
  end

  test "should get index" do
    get :index, user_id: users(:dan).id
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  test "should get new" do
    get :new, user_id: users(:dan)
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, user_id: users(:dan), photo: {
          description: @new_photo[:description],
          load_photo_file: photo_data,
          name: @new_photo[:name]
      }
    end

    assert_redirected_to user_photo_path(users(:dan), assigns(:photo))
  end

  test "should show photo" do
    get :show, user_id: @user, id: @photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user, id: @photo
    assert_response :success
  end

  test "should update photo (name)" do
    new_name = 'This is the photo\'s newest name'

    patch :update, user_id: @user.id, id: @photo.id,
          photo: {
              name: new_name
          }

    assert_redirected_to user_photo_path(@user, assigns(:photo))
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete :destroy, user_id: @user, id: @photo
    end

    assert_redirected_to user_photos_path(@user)
  end

  def photo_data
    ActionDispatch::Http::UploadedFile.new({
                                               filename: 'DSC01740.JPG',
                                               type: 'image/jpg',
                                               tempfile: IMAGE_SOURCE_FOLDER.join('DSC01740.JPG'),
                                               head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                           })
  end
end
