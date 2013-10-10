class CreatePhotosizes < ActiveRecord::Migration
  def change
    create_table :photosizes do |t|
      t.string :name, null: false
      t.integer :width
      t.integer :height

      t.timestamps
    end

    Photosize.create(name: 'original')
    Photosize.create(name: 'thumbnail',  width: 150,   height: 150)
    Photosize.create(name: 'large',      width: 2000,  height: 2000)
    Photosize.create(name: 'medium',     width: 1000,  height: 1000)
    Photosize.create(name: 'small',      width: 800,   height: 800)
  end
end
