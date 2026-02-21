class SkillsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_skill, only: [:show, :purchase]

  def index
    @categories = Category.all
    @skills = Skill.includes(:category).order(created_at: :desc)

    if params[:category].present?
      category = Category.friendly.find(params[:category])
      @skills = @skills.where(category: category)
    end

    if params[:search].present?
      @skills = @skills.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    @skills = @skills.page(params[:page]).per(12)
  end

  def show
    @related_skills = @skill.category.skills.where.not(id: @skill.id).limit(3)
  end

  def purchase
    @payment = @skill.create_payment!(
      amount: @skill.price,
      currency: 'cny',
      status: 'pending',
      user: current_user
    )

    redirect_to pay_payment_path(@payment), data: { turbo_method: :post }
  end

  private

  def set_skill
    @skill = Skill.friendly.find(params[:id])
  end
end
