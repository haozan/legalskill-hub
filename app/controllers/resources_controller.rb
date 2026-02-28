class ResourcesController < ApplicationController
  def index
    @resources = Resource.published.ordered.websites.by_tag(params[:tag])
    @resources = @resources.page(params[:page]).per(12)
  end

  def show
    @resource = Resource.find(params[:id])
  end
end
