class Admin::VideoResourcesController < Admin::BaseController
  before_action :set_video_resource, only: [:show, :edit, :update, :destroy]

  def index
    @video_resources = VideoResource.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @video_resource = VideoResource.new
  end

  def create
    @video_resource = VideoResource.new(video_resource_params)

    if @video_resource.save
      redirect_to admin_video_resource_path(@video_resource), notice: 'Video resource was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @video_resource.update(video_resource_params)
      redirect_to admin_video_resource_path(@video_resource), notice: 'Video resource was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video_resource.destroy
    redirect_to admin_video_resources_path, notice: 'Video resource was successfully deleted.'
  end

  private

  def set_video_resource
    @video_resource = VideoResource.find(params[:id])
  end

  def video_resource_params
    params.require(:video_resource).permit(:title, :bilibili_url, :duration, :views_count, :category_id, :cover_image)
  end
end
