class VideoResourcesController < ApplicationController
  before_action :set_video_resource, only: [:show]

  def index
    @categories = Category.all
    @videos = VideoResource.includes(:category).order(created_at: :desc)

    if params[:category].present?
      category = Category.friendly.find(params[:category])
      @videos = @videos.where(category: category)
    end

    @videos = @videos.page(params[:page]).per(12)
  end

  def show
    @video.increment_views!
    @related_videos = @video.category.video_resources.where.not(id: @video.id).limit(3)
  end

  private

  def set_video_resource
    @video = VideoResource.find(params[:id])
  end
end
