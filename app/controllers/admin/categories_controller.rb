class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.for_video.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @category = Category.new(category_type: "video")
  end

  def create
    @category = Category.new(category_params.merge(category_type: "video"))

    if @category.save
      redirect_to admin_category_path(@category), notice: "视频分类创建成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: "视频分类更新成功"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "视频分类已删除"
  end

  private

  def set_category
    @category = Category.for_video.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug, :description)
  end
end
