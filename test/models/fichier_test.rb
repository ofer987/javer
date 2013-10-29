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

class FichierTest < ActiveSupport::TestCase  
  def setup
    @new_photo = Photo.new do |photo|
        photo.description = 'This is a beautiful new photo'
        photo.name = "My mom's photo"
        photo.user_id = users(:dan).to_param
    end
    @new_photo.load_photo_file = photo_data
    @new_photo.save!
  end
  
  def teardown    
  end
  
  test "should remove fichier's file when the fichier is destroyed" do
    @new_photo.fichiers.each do |fichier|
      assert fichier.destroy, "error deleting the fichier for photosize = #{fichier.photosize}"

      # Ensure that the fichier's file was removed from the harddrive      
      refute (File.exists? fichier.absolute_filename), 
        "error deleting the file #{fichier.absolute_filename} for photosize = #{fichier.photosize}"
    end
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
end
