class SiteSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  # 快捷读取：SiteSetting.get("hero_video_url")
  def self.get(key)
    find_by(key: key)&.value
  end

  # 快捷写入：SiteSetting.set("hero_video_url", "https://...")
  def self.set(key, value)
    record = find_or_initialize_by(key: key)
    record.value = value
    record.save!
  end
end
