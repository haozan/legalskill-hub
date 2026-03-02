class AddCoverImageToVideoResources < ActiveRecord::Migration[7.2]
  def change
    add_column :video_resources, :cover_image, :string
  end
end
