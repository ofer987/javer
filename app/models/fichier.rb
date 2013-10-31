class Fichier < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # photo_id: foreign key, integer, not null
  # photosize_id: foreign key, integer, not null
  # created_at
  # updated_at

  belongs_to :photo
  belongs_to :photosize

  attr_accessor :saved_image

  before_destroy :before_destroy
  after_create :after_create
  after_update :after_update

  # get the filename
  def filename
    if (self.photosize.name == 'original')
      self.photo.filename
    else
      /^([^\.]+)\.(jpg)/i =~ self.photo.filename
      "#{$1}_#{self.photosize.name}.#{$2}"
    end
  end

  def absolute_filename
    File.join(self.photo.photo_store, self.filename)
  end

  private
    def before_destroy
      if File.delete(File.join(self.photo.photo_store, self.filename)) == 0
        raise "Could not delete file or file not found: #{fichier.filename}\n"
      end 
    end
    
    def after_create
      self.photo.destroy unless write_file
    end
    
    def after_update
      write_file
    end
  
    def write_file
      resized_image = self.saved_image

      begin
        # resize the image unless photosize is original
        unless self.photosize.name == 'original'
          resized_image = self.saved_image.resize_to_fit(self.photosize.width, self.photosize.height)
        end

        # write the image to file
        resized_image.write(self.absolute_filename)
      rescue
        return false
      ensure
        self.saved_image = nil
      end
    end
end
