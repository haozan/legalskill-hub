class CreateUserProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :user_profiles do |t|
      t.bigint :user_id, null: false
      t.string :name
      t.string :phone
      t.string :company
      t.string :province
      t.string :city
      t.string :district

      t.timestamps
    end

    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :phone, unique: true
    add_foreign_key :user_profiles, :users
  end
end
