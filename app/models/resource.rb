class Resource < ApplicationRecord
  RESOURCE_TYPES = %w[video website].freeze

  validates :title, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :resource_type, inclusion: { in: RESOURCE_TYPES }

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :videos, -> { where(resource_type: "video") }
  scope :websites, -> { where(resource_type: "website") }

  def video?
    resource_type == "video"
  end

  def website?
    resource_type == "website"
  end
end
