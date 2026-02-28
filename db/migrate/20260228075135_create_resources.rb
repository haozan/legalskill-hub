class CreateResources < ActiveRecord::Migration[7.2]
  def change
    create_table :resources do |t|
      t.string :title
      t.string :url
      t.string :resource_type, default: "website"
      t.text :description
      t.integer :position, default: 0
      t.boolean :published, default: true


      t.timestamps
    end
  end
end
