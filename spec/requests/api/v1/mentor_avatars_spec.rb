require 'rails_helper'

RSpec.describe "Api::V1::MentorAvatars", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/mentor_avatars/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/mentor_avatars/index"
      expect(response).to have_http_status(:success)
    end
  end

end
