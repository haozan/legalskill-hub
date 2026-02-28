require 'rails_helper'

RSpec.describe "Communities", type: :request do

  # Uncomment this if controller need authentication
  # let(:user) { last_or_create(:user) }
  # before { sign_in_as(user) }

  describe "GET /communities" do
    it "returns http success" do
      get communities_path
      expect(response).to be_success_with_view_check('index')
    end
  end
end
