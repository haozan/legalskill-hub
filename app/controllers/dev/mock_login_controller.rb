class Dev::MockLoginController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  before_action :ensure_development!

  # GET /dev/mock_login — list existing users to pick from
  def index
    @users = User.order(created_at: :desc).limit(20)
  end

  # POST /dev/mock_login — log in as the chosen user
  def create
    user = if params[:user_id].present?
             User.find(params[:user_id])
           else
             # Auto-create a dev test account
             User.find_or_create_by!(email: "dev@test.local") do |u|
               u.name          = "Dev 测试账号"
               u.wechat_openid = "dev_mock_openid_#{SecureRandom.hex(4)}"
               u.provider      = "wechat"
               u.verified      = true
             end
           end

    # 自动补全 profile，确保 dev 账号不被拦截到资料填写页
    unless user.profile_complete?
      user.profile || user.create_profile!
      user.profile.update!(
        name:     user.name.presence || "Dev 测试账号",
        phone:    "13800138#{user.id.to_s.rjust(3, '0')}",
        company:  "测试律所",
        province: "广东省",
        city:     "广州市",
        district: "天河区"
      )
    end

    session_record = user.sessions.create!
    cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

    redirect_to root_path, notice: "✅ 已模拟登录为：#{user.name}（#{user.email}）"
  end

  private

  def ensure_development!
    raise ActionController::RoutingError, "Not Found" unless Rails.env.development?
  end
end
