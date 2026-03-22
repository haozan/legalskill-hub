class Admin::WechatOrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @orders = WechatOrder.includes(:user).order(created_at: :desc)
    @orders = @orders.where(plan: params[:plan]) if params[:plan].present?
    @orders = @orders.where(status: params[:status]) if params[:status].present?
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(wechat_order_params)
      redirect_to admin_wechat_orders_path, notice: "订单已更新"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = WechatOrder.find(params[:id])
  end

  def wechat_order_params
    params.require(:wechat_order).permit(:status, :plan, :quantity, :description)
  end
end
