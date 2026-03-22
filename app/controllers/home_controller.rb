class HomeController < ApplicationController
  include HomeDemoConcern
  before_action :require_profile_complete, if: :user_signed_in?

  def index
    @featured_skills = Skill.includes(:category).order(download_count: :desc).limit(6)
    @skill_categories = Category.for_skill.order(:name)
    @hero_video_url   = SiteSetting.get("hero_video_url")
    @hero_video_title = SiteSetting.get("hero_video_title").presence || "青狮龙虾快速上手"
    @delivered_skills = DeliveredSkill.ordered
  end
end
