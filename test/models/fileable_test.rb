require 'test_helper'

IMAGE_SOURCE_FOLDER = Rails.root.join('test', 'resources', 'images')
IMAGE_DEST_FOLDER = Rails.root.join('test', 'assets', 'images', 'photos')

# For testing purposes
# The test photos should not be mixed in the real assets folder  
class Photo
  def photo_store
    IMAGE_DEST_FOLDER
  end
end

class FileableTest < ActiveSupport::TestCase
  def teardown
    # Remove the destination subdir
    FileUtils.rm_rf(IMAGE_DEST_FOLDER)

    # Recreate the destination  subdir
    FileUtils.mkdir_p(IMAGE_DEST_FOLDER)
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

    assert IMAGE_DEST_FOLDER.opendir.any? { |file| file == photo.filename }, "The file, #{photo.filename} was not saved"

    assert photo.fichiers.size > 0, "no fichiers were created"
    photo.fichiers.each do |fichier|
      assert IMAGE_DEST_FOLDER.opendir.any? { |file| file == fichier.filename },
             "Could not find the file (#{fichier.filename}) for photosize=#{fichier.photosize.name}"
    end
  end
  
  test 'should be able to save a new photo' do
    new_photo = Photo.new do |photo|
        photo.description = 'This is a beautiful new photo'
        photo.name = "My mom's photo"
        photo.user_id = users(:dan).to_param
    end
    new_photo.load_photo_file = photo_data
        
    assert new_photo.save, "not able to save the photo with #{IMAGE_SOURCE_FOLDER.join('DSC01740.JPG')}"
    
    # Assert that the fichiers exist
    assert new_photo.fichiers.size > 0, "did not create fichiers"
    
    new_photo.fichiers.each do |fichier|
      assert (File.exists? fichier.absolute_filename), 
        "did not create the file #{fichier.absolute_filename} for photosize = #{fichier.photosize}"
    end
  end

  test 'should reject file that does not exist' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = not_existing_photo_data
    refute photo.save, 'error: a photo with a non-existing file was created'

    refute IMAGE_DEST_FOLDER.opendir.any? { |file| file == 'not_real_photo.JPG' }
  end

  test 'should reject non-image filename' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = non_image_photo_data

    refute photo.valid?, "#{photo.errors.full_messages}"
  end
  
  test 'should delete files when destroying a photo' do
    photo = Photo.new(user: users(:dan), name: 'New Photo')
    photo.load_photo_file = photo_data
    photo.save!
    
    # Remember the created filenames before the fichier objects are deleted
    fichier_absolute_filenames = photo.fichiers.map &:absolute_filename
    assert photo.destroy, "error destroying the photo"
    
    # Assert that the files were deleted 
    fichier_absolute_filenames.each do |absolute_filename|
      refute (File.exists? absolute_filename), "error deleting the file #{absolute_filename}"
    end    
  end  

  private

    def photo_data
      filename = 'DSC01740.JPG'
      @tmpfile = Tempfile.new(filename)
      File.open(@tmpfile.path, 'wb') do |dest_file|
        dest_file.write(IO.read(IMAGE_SOURCE_FOLDER.join(filename)))
      end
      ActionDispatch::Http::UploadedFile.new({
          filename: 'DSC01740.JPG',
          type: 'image/jpg',
          tempfile: @tmpfile,
          head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                            })
    end

    def not_existing_photo_data
      filename = 'not_real_photo.JPG'
      @tmpfile = Tempfile.new(filename)
      ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'not_real_photo.JPG',
                                                 type: 'image/jpg',
                                                 tempfile: @tmpfile,
                                                 head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                             })
    end

    def non_image_photo_data
      filename = 'photos.js.coffee'
      @tmpfile = Tempfile.new(filename)
      File.open(@tmpfile.path, 'wb') do |dest_file|
        dest_file.write(IO.read(IMAGE_SOURCE_FOLDER.join(filename)))
      end
      ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'photos.js.coffee',
                                                 type: 'image/jpg',
                                                 tempfile: @tmpfile,
                                                 head: "Content-Disposition: form-data; name=\"photo[load_photo_file]\"; filename=\"DSC01740.JPG\"\r\nContent-Type: image/jpeg\r\n"
                                             })
    end
end