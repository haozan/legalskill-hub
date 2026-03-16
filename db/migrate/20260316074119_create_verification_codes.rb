class CreateVerificationCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :verification_codes do |t|
      t.string :mobile,     null: false
      t.string :code,       null: false
      t.string :purpose,    null: false, default: "profile"
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :verification_codes, [ :mobile, :purpose ]
  end
end
