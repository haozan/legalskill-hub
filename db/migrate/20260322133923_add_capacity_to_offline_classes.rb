class AddCapacityToOfflineClasses < ActiveRecord::Migration[7.2]
  def change
    add_column :offline_classes, :capacity, :integer, default: 10, null: false

  end
end
