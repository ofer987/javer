class CreateFichiers < ActiveRecord::Migration
  def change
    create_table :fichiers do |t|
      t.references :photo, index: true
      t.references :filesize_type, index: true

      t.timestamps
    end
  end
end
