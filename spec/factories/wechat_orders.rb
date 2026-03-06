FactoryBot.define do
  factory :wechat_order do

    out_trade_no { "MyString" }
    amount { 1 }
    status { "MyString" }
    user_id { nil }
    wechat_transaction_id { "MyString" }
    description { "MyString" }

  end
end
