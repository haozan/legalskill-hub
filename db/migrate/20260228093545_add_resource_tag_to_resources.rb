class AddResourceTagToResources < ActiveRecord::Migration[7.2]
  def change
    add_column :resources, :resource_tag, :string

  end
end
