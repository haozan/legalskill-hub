class OfflineClassEnrollment < ApplicationRecord
  belongs_to :offline_class
  belongs_to :user
  belongs_to :payment, optional: true

  validates :attendee_count, numericality: { greater_than: 0 }
  validates :offline_class_id, uniqueness: { scope: :user_id, message: "你已经报名了这个班次" }

  after_create :update_class_counts
  after_destroy :update_class_counts

  private

  def update_class_counts
    offline_class.recalculate_counts!
  end
end
