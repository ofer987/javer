class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.string :name, null: false, default: ''

      t.timestamps
    end

    UserType.create(name: 'admin')
    UserType.create(name: 'member')
  end
end
