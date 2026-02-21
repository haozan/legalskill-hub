class Skill < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category
  has_one :payment, as: :payable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :author_name, presence: true
  validates :category, presence: true
  validates :template_count, numericality: { greater_than_or_equal_to: 0 }
  validates :download_count, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :slug, presence: true, uniqueness: true

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
    "noreply@legalskillhub.com"
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
