class HomeController < ApplicationController
  include HomeDemoConcern

  def index
    @featured_skills = Skill.includes(:category).order(download_count: :desc).limit(6)
    @skill_categories = Category.for_skill.order(:name)
  end
end
