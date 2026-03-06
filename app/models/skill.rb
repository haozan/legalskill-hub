class Skill < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category

  # category 必须是 skill 类型
  validates :category, presence: true
  validate :category_must_be_skill_type

  has_one :payment, as: :payable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :author_name, presence: true
  validates :template_count, numericality: { greater_than_or_equal_to: 0 }
  validates :download_count, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :slug, presence: true, uniqueness: true

  private

  def category_must_be_skill_type
    return unless category
    errors.add(:category, "必须是技能分类") unless category.category_type == "skill"
  end

  public

  def should_generate_new_friendly_id?
    title_changed?
  end

  def increment_downloads!
    increment!(:download_count)
  end

  # Required methods for Stripe payment integration
  def customer_name
    "Skill Purchase"
  end

  def customer_email
    "noreply@qingclaw.com"
  end

  def payment_description
    "#{title} - 法律技能包"
  end

  def stripe_mode
    'payment'
  end

  def stripe_line_items
    [{
      price_data: {
        currency: 'cny',
        product_data: {
          name: title,
          description: description.truncate(200)
        },
        unit_amount: (price * 100).to_i
      },
      quantity: 1
    }]
  end
end
