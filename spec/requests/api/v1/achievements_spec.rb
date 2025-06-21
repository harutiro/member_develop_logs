require 'rails_helper'

RSpec.describe "Api::V1::Achievements", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/achievements/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/achievements/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/achievements/show"
      expect(response).to have_http_status(:success)
    end
  end
end
