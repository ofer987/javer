class CreateUserTypesMembers < ActiveRecord::Migration
  def change
    create_table :user_types_members do |t|
      t.references :user, index: true
      t.text :description, null: false, default: ''

      t.timestamps
    end
  end
end
