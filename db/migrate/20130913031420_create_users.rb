class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :user_type, index: true
      t.string :password_digest, null: false
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''

      t.timestamps
    end
  end
end
