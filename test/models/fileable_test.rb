require 'test_helper'

IMAGE_SOURCE_FOLDER = Rails.root.join('test', 'assets', 'images')
IMAGE_DESTINATION_FOLDER = Rails.root.join('test', 'website', 'images')

class Photo
  def photo_store
    IMAGE_DESTINATION_FOLDER
  end
end

class FileableTest < ActiveSupport::TestCase
  setup do
    # Remove the images subdir
    FileUtils.rm_rf(IMAGE_DESTINATION_FOLDER)

    # Recreate the images subdir
    FileUtils.mkdir_p(IMAGE_DESTINATION_FOLDER)
  end

  test 'should be able to upload file' do
    photo = Photo.new
    photo.load_photo_file = photo_data

    assert photo.filename == photo_data.original_filename, 'The filename was not set'
  end

  test 'should be able to write the file to disk' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = photo_data

    photo.save
    assert photo.valid?, "#{photo.errors.full_messages}"

    assert IMAGE_DESTINATION_FOLDER.opendir.any? { |file| file == photo.filename }, 'The file was not saved'

    photo.fichiers.each do |fichier|
      assert IMAGE_DESTINATION_FOLDER.opendir.any? { |file| file == fichier.filename },
             "Could not find the file (#{fichier.filename}) for photosize=#{fichier.photosize.name}"
    end
  end

  test 'should reject file that does not exist' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = not_existing_photo_data
    photo.save

    assert !IMAGE_DESTINATION_FOLDER.opendir.any? { |file| file == photo.filename }
  end

  test 'should reject non-image filename' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = non_image_photo_data

    assert !photo.valid?, "#{photo.errors.full_messages}"
  end

  private

    def photo_data
      ActionDispatch::Http::UploadedFile.new({
          filename: 'DSC01740.JPG',
          type: 'image/jpg',
          tempfile: IMAGE_SOURCE_FOLDER.join('DSC01740.JPG'),
          head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                            })
    end

    def not_existing_photo_data
      ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'not_real_photo.JPG',
                                                 type: 'image/jpg',
                                                 tempfile: IMAGE_SOURCE_FOLDER.join('not_real_photo.JPG'),
                                                 head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                             })
    end

    def non_image_photo_data
      ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'photos.js.coffee',
                                                 type: 'image/jpg',
                                                 tempfile: IMAGE_SOURCE_FOLDER.join('photo.js.coffee'),
                                                 head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                             })
    end
end