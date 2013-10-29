class Photo < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # user_id: foreign key, not null
  # name: nvarchar(255), not null, default: ''
  # description: nvarchar(255), not null, default: ''
  # filename: nvarchar(255), not null
  # taken_at: datetime, null
  # created_at
  # updated_at

  belongs_to :user
  has_many :fichiers, dependent: :destroy

  validates_presence_of :user_id
  #validates_associated :user

  #validates_length_of :name, minimum: 0, allow_nil: false
  validates_presence_of :name
  #validates :description, presence: true, allow_blank: true, allow_nil: false

  validates_presence_of :filename
  validates_format_of :filename, with: /\A[\w\d_ -]+\.jpg\z/i

  before_create :before_create
  before_update :before_update

  # Root directory of the photo public/photos
  def photo_store
    Rails.root.join('app', 'assets', 'images', 'photos')
  end

  def select_fichier(name)
    if name.is_a? Photosize
      self.fichiers.find_by_photosize_id(name)
    else
      self.fichiers.find_by_photosize_id(Photosize[name])
    end
  end

  def add_fichier(name)
    if (self.select_fichier(name) == nil)
      self.fichiers.create(photosize: Photosize[name])
    else
      self.select_fichier(name)
    end
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

  def before_update
    write_file unless @photo_data.nil?
  end

  def before_create
    return false if @photo_data.nil?

    write_file
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

  def write_file
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
  end

  def set_metadata
    # Store the date the image as taken
    image_datetime = @saved_image.get_exif_by_entry('DateTime')[0][1]
    self.taken_at = DateTime.strptime(image_datetime, '%Y:%m:%d %H:%M:%S') if image_datetime != nil
  end

  def set_fichiers
    Photosize.all.each do |photosize|
      case photosize.name
        when 'original'
          # Just create a fichier record in the db
          # no need to save the file to hdd because the original file has
          # already been saved
          fichier = self.fichiers.build(photosize: photosize)
          fichier.saved_image = @saved_image
        when 'thumbnail'
          # Always create a small version of this photo,
          fichier = self.fichiers.build(photosize: photosize)
          fichier.saved_image = @saved_image
        else
          if photosize.width < @saved_image.columns or photosize.height < @saved_image.rows then
            fichier = self.fichiers.build(photosize: photosize)
            fichier.saved_image = @saved_image
          end
      end
    end
  end

  def validate_has_unique_fichiers
    self.fichiers.each do |verify1|
      self.fichiers.each do |verify2|
        next if verify1 == verify2
        if verify1.photosize == verify2.photosize
          errors.add(:base, "duplicate fichiers of type #{verify1.photosize.name}")
          return
        end
      end
    end
  end
end
