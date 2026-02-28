class Identity::PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[ edit update ]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    if @user = User.find_by(email: params[:user][:email], verified: true)
      send_password_reset_email
      redirect_to sign_in_path, notice: "Check your email for reset instructions"
    else
      redirect_to new_identity_password_reset_path, alert: "You can't reset your password until you verify your email"
    end
  end

  def update
    if @user.update(user_params)
      redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in"
    else
      flash.now[:alert] = handle_password_errors(@user)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    # 防御性处理：移除可能由邮件客户端添加的空白字符
    raw_sid = params[:sid]
    trimmed_sid = raw_sid&.strip
    
    @user = User.find_by_token_for!(:password_reset, trimmed_sid)
  rescue StandardError
    redirect_to new_identity_password_reset_path, alert: "该密码重置链接已失效"
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def send_password_reset_email
    UserMailer.with(user: @user).password_reset.deliver_later
  end
end
