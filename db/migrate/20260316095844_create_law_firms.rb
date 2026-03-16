class CreateLawFirms < ActiveRecord::Migration[7.2]
  def change
    create_table :law_firms do |t|
      t.string :name
      t.string :province
      t.string :city
      t.string :district

      t.index :name, unique: true

      t.timestamps
    end
  end
end
