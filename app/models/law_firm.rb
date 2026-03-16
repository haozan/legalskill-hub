class LawFirm < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  scope :search_by_name, ->(q) { where("name LIKE ?", "%#{q}%").order(:name).limit(10) }
end
