module Wechat
  module Pay
    # Polled by frontend to check if payment is complete.
    class StatusController < ApplicationController
      before_action :authenticate_user!

      def show
        order = WechatOrder.find_by!(out_trade_no: params[:out_trade_no], user: current_user)

        # If still pending, query WeChat API once to refresh
        if order.pending?
          begin
            result = WechatPayService.new.query_order(order.out_trade_no)
            if result["trade_state"] == "SUCCESS"
              order.update!(
                status:                "paid",
                wechat_transaction_id: result["transaction_id"]
              )
            end
          rescue => e
            Rails.logger.warn "[WechatPay] status query failed: #{e.message}"
          end
        end

        render json: { status: order.status }
      end
    end
  end
end
