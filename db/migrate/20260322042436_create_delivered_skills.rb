class CreateDeliveredSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :delivered_skills do |t|
      t.integer :position
      t.string :name
      t.text :scenario
      t.string :time_saved
      t.string :cost_saved
      t.string :demo_video_url

      t.timestamps
    end
  end
end
