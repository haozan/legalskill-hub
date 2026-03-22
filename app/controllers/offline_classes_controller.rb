class OfflineClassesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offline_class, only: [:enroll, :unenroll]

  def index
    @offline_classes = OfflineClass.upcoming
  end

  def enroll
    # 检查资格：是否有已付款的方案三订单
    plan3_order = current_user.wechat_orders.paid.plan3.order(created_at: :desc).first

    unless plan3_order
      respond_to do |format|
        format.html { redirect_to root_path, alert: "需要购买方案三（线下课程）才能报名" }
        format.json { render json: { error: "无报名资格" }, status: :forbidden }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash-messages",
            partial: "shared/flash", locals: { message: "需要购买方案三才能报名", type: "error" })
        }
      end
      return
    end

    # 检查是否已报名
    if @offline_class.enrolled?(current_user)
      respond_to do |format|
        format.html { redirect_to root_path, alert: "你已经报名了这个班次" }
        format.json { render json: { error: "已报名" }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash-messages",
            partial: "shared/flash", locals: { message: "你已报名了这个班次", type: "warning" })
        }
      end
      return
    end

    # 检查名额
    attendee_count = plan3_order.quantity || 1
    if @offline_class.spots_remaining < attendee_count
      respond_to do |format|
        format.html { redirect_to root_path, alert: "班次名额不足（剩余 #{@offline_class.spots_remaining} 人）" }
        format.json { render json: { error: "名额不足" }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash-messages",
            partial: "shared/flash", locals: { message: "班次名额不足", type: "error" })
        }
      end
      return
    end

    enrollment = @offline_class.offline_class_enrollments.build(
      user: current_user,
      attendee_count: attendee_count
    )

    if enrollment.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "报名成功！共报名 #{attendee_count} 人" }
        format.json { render json: { success: true, attendee_count: attendee_count } }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("offline-class-#{@offline_class.id}",
              partial: "offline_classes/class_card",
              locals: { oc: @offline_class.reload, plan3_order: plan3_order, current_user: current_user }),
            turbo_stream.replace("flash-messages",
              partial: "shared/flash", locals: { message: "报名成功！共报名 #{attendee_count} 人", type: "success" })
          ]
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: enrollment.errors.full_messages.join("，") }
        format.json { render json: { error: enrollment.errors.full_messages }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("flash-messages",
            partial: "shared/flash", locals: { message: enrollment.errors.full_messages.join("，"), type: "error" })
        }
      end
    end
  end

  def unenroll
    enrollment = @offline_class.offline_class_enrollments.find_by(user: current_user)
    if enrollment
      enrollment.destroy
      redirect_to root_path, notice: "已取消报名"
    else
      redirect_to root_path, alert: "未找到报名记录"
    end
  end

  private

  def set_offline_class
    @offline_class = OfflineClass.find(params[:id])
  end
end
