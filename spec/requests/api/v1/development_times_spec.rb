require 'rails_helper'

RSpec.describe "Api::V1::DevelopmentTimes", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/development_times/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/development_times/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/development_times/show"
      expect(response).to have_http_status(:success)
    end
  end

end
