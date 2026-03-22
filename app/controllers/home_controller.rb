class HomeController < ApplicationController
  include HomeDemoConcern
  before_action :require_profile_complete, if: :user_signed_in?

  def index
    @featured_skills = Skill.includes(:category).order(download_count: :desc).limit(6)
    @skill_categories = Category.for_skill.order(:name)
    @hero_video_url   = SiteSetting.get("hero_video_url")
    @hero_video_title = SiteSetting.get("hero_video_title").presence || "青狮龙虾快速上手"
    @delivered_skills = DeliveredSkill.ordered
    @offline_classes  = OfflineClass.upcoming.where(status: ["open", "full"])

    # 当前用户的方案三资格（已付款订单）
    if user_signed_in?
      @plan3_order = current_user.wechat_orders.paid.plan3.order(created_at: :desc).first
    end
  end
end
