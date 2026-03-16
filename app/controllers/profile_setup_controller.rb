# 微信登录后，引导新用户填写基本资料（手机验证 + 律所 + 省市区）
# GET  /profile/setup     → 展示表单
# POST /profile/setup     → 保存资料
class ProfileSetupController < ApplicationController
  before_action :authenticate_user!
  # 已完善资料的用户不需要再来这里
  before_action :redirect_if_complete

  def show
  end

  def update
    profile = current_user.profile || current_user.build_profile

    mobile  = params[:mobile].to_s.strip
    code    = params[:code].to_s.strip
    company = params[:company].to_s.strip
    province = params[:province].to_s.strip
    city     = params[:city].to_s.strip
    district = params[:district].to_s.strip
    name     = params[:name].to_s.strip

    # 字段校验
    unless mobile =~ UserProfile::PHONE_REGEXP
      return render_error("手机号格式不正确，请输入 11 位大陆手机号")
    end

    if company.blank?
      return render_error("律所名称不能为空")
    end

    if province.blank? || city.blank?
      return render_error("请选择省市")
    end

    # 手机号唯一性校验（排除自己）
    if UserProfile.where(phone: mobile).where.not(user_id: current_user.id).exists?
      return render_error("该手机号已被其他账号使用")
    end

    # 短信验证码校验（dev 环境跳过）
    unless Rails.env.development?
      unless VerificationCode.authenticate(mobile, code, purpose: "profile")
        return render_error("验证码不正确或已过期，请重新获取")
      end
    end

    profile.assign_attributes(
      name:     name.presence || current_user.name,
      phone:    mobile,
      company:  company,
      province: province,
      city:     city,
      district: district
    )

    if profile.save
      # 同步 user.name
      current_user.update(name: profile.name) if profile.name.present?
      redirect_to root_path, notice: "资料填写完成，欢迎使用青狮龙虾！"
    else
      @error = profile.errors.full_messages.first
      render :show, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_complete
    redirect_to root_path if current_user.profile_complete?
  end

  def render_error(msg)
    @error = msg
    render :show, status: :unprocessable_entity
  end
end
