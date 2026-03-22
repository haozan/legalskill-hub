class Admin::OfflineClassesController < Admin::BaseController
  before_action :set_offline_class, only: [:show, :edit, :update, :destroy]

  def index
    @offline_classes = OfflineClass.order(date: :asc)
  end

  def show
    @enrollments = @offline_class.offline_class_enrollments.includes(:user)
  end

  def new
    @offline_class = OfflineClass.new(capacity: 10, status: "open")
  end

  def create
    @offline_class = OfflineClass.new(offline_class_params)
    if @offline_class.save
      redirect_to admin_offline_classes_path, notice: "班次创建成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @offline_class.update(offline_class_params)
      redirect_to admin_offline_classes_path, notice: "班次更新成功"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offline_class.destroy
    redirect_to admin_offline_classes_path, notice: "班次已删除"
  end

  private

  def set_offline_class
    @offline_class = OfflineClass.find(params[:id])
  end

  def offline_class_params
    params.require(:offline_class).permit(:title, :city, :date, :location, :description, :capacity, :status)
  end
end
