module Fileable
  module ClassMethods
  end

  module InstanceMethods
    # Root directory of the photo public/photos
    def photo_store
      Rails.root.join('app', 'assets', 'images', 'photos')
    end

    # "f.file_field :load_photo_file" in the view triggers Rails to invoke this method
    # This method only store the information
    # The file saving is done in before_save
    def load_photo_file=(data)
      if data.respond_to? ('original_filename')
        filename = data.original_filename
      else
        raise 'Error: file does not have a filename'
      end

      # Store the data for later use
      self.filename = filename
      @photo_data = data
    end

    private

    def write_file
      # Validation
      if @photo_data == nil
        return false
      end

      # Load the image
      begin
        @saved_image = Magick::ImageList.new(@photo_data.tempfile)
      rescue
        return false
      end

      # Set the metadata
      set_metadata

      # Create files of different sizes and fichier relationships
      set_fichiers

      # Clear the image data from application memory
      @photo_data = nil
      #@saved_image = nil
    end

    def filename=(new_filename)
      /^([^\.]+)\.(jpg|png)/i =~ new_filename
      new_filename_simple = $1
      new_filename_extension = $2

      # If another photo already uses the same file,
      # then add a number to the end of the filename untill unique
      i = 0
      while true
        existing_full_filename = File.join(self.photo_store, new_filename)

        if File.exists?(existing_full_filename)
          i=i+1
          new_filename = "#{new_filename_simple}_#{i.to_s}.#{new_filename_extension}"
        else
          break
        end
      end

      self[:filename] = new_filename
    end

    def set_metadata
      # Store the date the image as taken
      image_datetime = @saved_image.get_exif_by_entry('DateTime')[0][1]
      self.taken_at = DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S') if image_datetime != nil
    end

    def set_fichiers
      FilesizeType.all.each do |filesize_type|
        case filesize_type.name
          when 'original'
            # Just create a fichier record in the db
            # no need to save the file to hdd because the original file has
            # already been saved
            fichier = self.fichiers.build(filesize_type: filesize_type)
            fichier.saved_image = @saved_image
          when 'thumbnail'
            # Always create a small version of this photo,
            fichier = self.fichiers.build(filesize_type: filesize_type)
            fichier.saved_image = @saved_image
          else
            if filesize_type.width < @saved_image.columns or filesize_type.height < @saved_image.rows then
              fichier = self.fichiers.build(filesize_type: filesize_type)
              fichier.saved_image = @saved_image
            end
        end
      end
    end

    def init_taken_at
      # Default value
      self.taken_at = DateTime.now
    end

    def validate_has_unique_fichiers
      self.fichiers.each do |verify1|
        self.fichiers.each do |verify2|
          next if verify1 == verify2
          if verify1.filesize_type == verify2.filesize_type
            errors.add(:base, "duplicate fichiers of type #{verify1.filesize_type.name}")
            return
          end
        end
      end
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send   :include, InstanceMethods

    receiver.class_eval do
      before_validation :init_taken_at
      before_save :write_file

      #validates :validate_has_unique_fichiers
    end
  end
end