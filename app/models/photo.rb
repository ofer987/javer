class Photo < ActiveRecord::Base
  # id: primary key, not null, auto increment
  # user_id: foreign key, not null
  # name: nvarchar(255), not null, default: ''
  # description: nvarchar(255), not null, default: ''
  # filename: nvarchar(255), not null
  # taken_at: datetime, null
  # created_at
  # updated_at

  include Fileable

  belongs_to :user
  has_many :fichiers

  validates_presence_of :user_id
  #validates_associated :user

  #validates_length_of :name, minimum: 0, allow_nil: false
  #validates :name, :presence: true, allow_blank: true, allow_nil: false
  #validates :description, presence: true, allow_blank: true, allow_nil: false

  validates_presence_of :filename, :taken_at
  validates_format_of :filename, with: /\A[\w\d_ -]+\.jpg\z/i

  def select_fichier(name)
    self.fichiers.find_by_filesize_type_id(FilesizeType[name])
  end

  def add_fichier(name)
    if (self.select_fichier(name) == nil)
      self.fichiers.create(filesize_type: FilesizeType[name])
    else
      self.select_fichier(name)
    end
  end
end
