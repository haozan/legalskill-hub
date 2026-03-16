class VerificationCode < ApplicationRecord
  EXPIRED_DURATION = 5.minutes
  MAXIMUM_ATTEMPTS = 5
  PHONE_REGEXP = /\A1[3-9]\d{9}\z/

  validates :mobile, presence: true, format: { with: PHONE_REGEXP, message: "格式不正确，请输入 11 位大陆手机号" }
  validates :code, presence: true
  validates :expires_at, presence: true
  validates :purpose, presence: true

  before_validation :normalize_mobile, on: :create
  before_validation :generate_code,    on: :create
  before_validation :set_expires_at,   on: :create

  scope :expired, -> { where("expires_at < ?", Time.current) }
  scope :for_purpose, ->(p) { where(purpose: p) }

  # 生成（或重新生成）验证码，同时清理该手机号旧的过期记录
  def self.regenerate!(mobile, purpose: "profile")
    transaction do
      where(mobile: mobile, purpose: purpose).expired.delete_all
      create!(mobile: mobile, purpose: purpose)
    end
  end

  # 验证码校验
  def self.authenticate(mobile, submitted_code, purpose: "profile")
    where(mobile: mobile, purpose: purpose).each do |record|
      return true if record.send(:authenticate!, submitted_code)
    end
    false
  end

  private

  def authenticate!(submitted_code)
    return false if expired? || attempts_exceeded?
    if code == submitted_code.to_s.strip
      true
    else
      increment!(:failed_attempts)
      false
    end
  end

  def expired?
    expires_at < Time.current
  end

  def attempts_exceeded?
    failed_attempts >= MAXIMUM_ATTEMPTS
  end

  def normalize_mobile
    self.mobile = mobile.to_s.strip
  end

  def generate_code
    self.code = rand(0..9999).to_s.rjust(4, "0")
  end

  def set_expires_at
    self.expires_at = Time.current + EXPIRED_DURATION
  end
end
