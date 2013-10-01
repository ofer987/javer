class Fichier < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # photo_id: foreign key, integer, not null
  # filesize_type_id: foreign key, integer, not null
  # created_at
  # updated_at

  belongs_to :photo
  belongs_to :filesize_type

  attr_accessor :saved_image

  after_save :write_file

  # get the filename
  def filename
    if (self.filesize_type.name == 'original')
      self.photo.filename
    else
      /^([^\.]+)\.(jpg)/i =~ self.photo.filename
      "#{$1}_#{self.filesize_type.name}.#{$2}"
    end
  end

  def absolute_filename
    File.join(self.photo.photo_store, self.filename)
  end

  private
    def write_file
      resized_image = self.saved_image

      begin
        # resize the image unless filesize_type is original
        unless self.filesize_type.name == 'original'
          resized_image = self.saved_image.resize_to_fit(self.filesize_type.width, self.filesize_type.height)
        end

        # write the image to file
        resized_image.write(self.absolute_filename)
      rescue
        return false
      end
    end
end
