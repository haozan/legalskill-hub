require 'rails_helper'

RSpec.describe "Video resources", type: :request do

  # Uncomment this if controller need authentication
  # let(:user) { last_or_create(:user) }
  # before { sign_in_as(user) }

  describe "GET /video_resources" do
    it "returns http success" do
      get video_resources_path
      expect(response).to be_success_with_view_check('index')
    end
  end

  describe "GET /video_resources/:id" do
    let(:video_resource_record) { create(:video_resource) }

    it "returns http success" do
      get video_resource_path(video_resource_record)
      expect(response).to be_success_with_view_check('show')
    end
  end
end
