module Wechat
  module Pay
    class OrdersController < ApplicationController
      before_action :authenticate_user!

      TRIAL_AMOUNT      = 100  # 1 yuan in fen
      TRIAL_DESCRIPTION = "青狮法律技能平台 - 试用体验"

      def new
        # Show payment page if user has no paid order yet
        @existing_paid = WechatOrder.paid.find_by(user: current_user)
        @amount_yuan   = TRIAL_AMOUNT / 100.0
      end

      def success
        @order = WechatOrder.paid.find_by!(user: current_user)
      rescue ActiveRecord::RecordNotFound
        redirect_to wechat_pay_order_new_path, alert: "未找到支付记录"
      end

      def create
        # Idempotent: reuse existing pending order for same user if present
        order = WechatOrder.pending.find_or_initialize_by(user: current_user) do |o|
          o.out_trade_no = SecureRandom.hex(16)
          o.amount       = TRIAL_AMOUNT
          o.description  = TRIAL_DESCRIPTION
        end

        unless order.persisted?
          order.out_trade_no = SecureRandom.hex(16)
          order.amount       = TRIAL_AMOUNT
          order.description  = TRIAL_DESCRIPTION
          order.save!
        end

        service = WechatPayService.new
        result  = service.create_native_order(
          out_trade_no: order.out_trade_no,
          amount:       order.amount,
          description:  order.description
        )

        qr = RQRCode::QRCode.new(result[:code_url])
        @qr_svg        = qr.as_svg(module_size: 4, standalone: true, use_path: true)
        @out_trade_no  = order.out_trade_no
        @amount_yuan   = order.amount_yuan

        render :show
      rescue => e
        Rails.logger.error "[WechatPay] create order failed: #{e.message}"
        flash[:alert] = "创建支付订单失败，请稍后重试"
        redirect_to wechat_pay_order_new_path
      end
    end
  end
end
