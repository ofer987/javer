class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :user, index: true
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :filename, null: false
      t.datetime :taken_at, null: true

      t.timestamps
    end
  end
end
