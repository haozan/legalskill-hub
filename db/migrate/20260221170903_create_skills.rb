class CreateSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :skills do |t|
      t.string :title
      t.text :description
      t.decimal :price, default: 99
      t.references :category
      t.string :author_name
      t.integer :template_count, default: 0
      t.integer :download_count, default: 0
      t.decimal :rating, default: 0
      t.string :slug

      t.index :slug, unique: true

      t.timestamps
    end
  end
end
