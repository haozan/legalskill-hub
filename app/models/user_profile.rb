class UserProfile < ApplicationRecord
  belongs_to :user

  PHONE_REGEXP = /\A1[3-9]\d{9}\z/

  validates :phone, uniqueness: true, allow_nil: true
  validates :phone, format: { with: PHONE_REGEXP, message: "格式不正确，请输入 11 位大陆手机号" }, allow_nil: true
  validates :company, presence: true, on: :complete
  validates :phone,   presence: true, on: :complete
  validates :province, :city, presence: true, on: :complete
end
