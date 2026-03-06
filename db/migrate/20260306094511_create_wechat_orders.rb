class CreateWechatOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :wechat_orders do |t|
      t.string :out_trade_no
      t.integer :amount
      t.string :status, default: "pending"
      t.bigint :user_id
      t.string :wechat_transaction_id
      t.string :description

      t.index :out_trade_no, unique: true

      t.timestamps
    end
  end
end
