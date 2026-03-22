class AddQuantityToWechatOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :wechat_orders, :quantity, :integer, default: 1, null: false

  end
end
