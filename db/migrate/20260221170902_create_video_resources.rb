class CreateVideoResources < ActiveRecord::Migration[7.2]
  def change
    create_table :video_resources do |t|
      t.string :title
      t.string :bilibili_url
      t.string :duration
      t.integer :views_count, default: 0
      t.references :category


      t.timestamps
    end
  end
end
