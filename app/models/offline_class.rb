class OfflineClass < ApplicationRecord
  has_many :offline_class_enrollments, dependent: :destroy
  has_many :enrolled_users, through: :offline_class_enrollments, source: :user

  STATUSES = %w[open full cancelled].freeze

  validates :title, presence: true
  validates :city, presence: true
  validates :date, presence: true
  validates :location, presence: true
  validates :capacity, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES }

  scope :open, -> { where(status: "open") }
  scope :upcoming, -> { where("date >= ?", Date.today).order(date: :asc) }
  scope :past, -> { where("date < ?", Date.today).order(date: :desc) }

  def spots_remaining
    capacity - attendees_count
  end

  def full?
    spots_remaining <= 0
  end

  def open?
    status == "open" && !full?
  end

  def enrolled?(user)
    return false unless user
    offline_class_enrollments.exists?(user: user)
  end

  # 同步更新 attendees_count 和 status
  def recalculate_counts!
    total = offline_class_enrollments.sum(:attendee_count)
    new_status = (total >= capacity) ? "full" : "open"
    update_columns(attendees_count: total, status: new_status)
  end
end
