class Resource < ApplicationRecord
  RESOURCE_TYPES = %w[video website].freeze
  RESOURCE_TAGS = %w[local_cloud api_cloud ai_api].freeze
  RESOURCE_TAG_NAMES = {
    'local_cloud' => '本地龙虾',
    'api_cloud' => '云端龙虾',
    'ai_api' => '大模型 API'
  }.freeze

  validates :title, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :resource_type, inclusion: { in: RESOURCE_TYPES }
  validates :resource_tag, inclusion: { in: RESOURCE_TAGS }, allow_blank: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, created_at: :desc) }
  scope :videos, -> { where(resource_type: "video") }
  scope :websites, -> { where(resource_type: "website") }
  scope :by_tag, ->(tag) { where(resource_tag: tag) if tag.present? }

  def video?
    resource_type == "video"
  end

  def website?
    resource_type == "website"
  end

  def tag_name
    RESOURCE_TAG_NAMES[resource_tag]
  end
end
