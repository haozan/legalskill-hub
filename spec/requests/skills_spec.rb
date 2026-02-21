require 'rails_helper'

RSpec.describe "Skills", type: :request do

  let(:user) { last_or_create(:user) }
  before { sign_in_as(user) }

  describe "GET /skills" do
    it "returns http success" do
      get skills_path
      expect(response).to be_success_with_view_check('index')
    end
  end

  describe "GET /skills/:id" do
    let(:skill_record) { create(:skill) }

    it "returns http success" do
      get skill_path(skill_record)
      expect(response).to be_success_with_view_check('show')
    end
  end
end
