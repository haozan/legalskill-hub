class Admin::SkillCategoriesController < Admin::BaseController
  before_action :set_skill_category, only: [:show, :edit, :update, :destroy]

  def index
    @skill_categories = Category.for_skill.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @skill_category = Category.new(category_type: "skill")
  end

  def create
    @skill_category = Category.new(skill_category_params.merge(category_type: "skill"))

    if @skill_category.save
      redirect_to admin_skill_category_path(@skill_category), notice: "技能分类创建成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill_category.update(skill_category_params)
      redirect_to admin_skill_category_path(@skill_category), notice: "技能分类更新成功"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill_category.destroy
    redirect_to admin_skill_categories_path, notice: "技能分类已删除"
  end

  private

  def set_skill_category
    @skill_category = Category.for_skill.find(params[:id])
  end

  def skill_category_params
    params.require(:category).permit(:name, :slug, :description)
  end
end
