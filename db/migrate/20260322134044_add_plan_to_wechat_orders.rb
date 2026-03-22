class AddPlanToWechatOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :wechat_orders, :plan, :string

  end
end
