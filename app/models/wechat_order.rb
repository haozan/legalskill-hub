class WechatOrder < ApplicationRecord
  belongs_to :user, optional: true

  STATUSES = %w[pending paid failed closed].freeze

  validates :out_trade_no, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :paid, -> { where(status: "paid") }
  scope :recent, -> { order(created_at: :desc) }

  def paid?
    status == "paid"
  end

  def pending?
    status == "pending"
  end

  def amount_yuan
    amount / 100.0
  end
end
