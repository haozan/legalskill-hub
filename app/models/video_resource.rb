class VideoResource < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :bilibili_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
  validates :category, presence: true
  validates :views_count, numericality: { greater_than_or_equal_to: 0 }

  def increment_views!
    increment!(:views_count)
  end
end
