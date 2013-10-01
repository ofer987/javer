class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.string :name, null: false, default: ''

      t.timestamps
    end

    UserType.create do |user_type|
      user_type.name = 'admin'
    end

    UserType.create do |user_type|
      user_type.name = 'member'
    end
  end
end
