require 'rails_helper'

RSpec.describe "DevelopmentTimes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/development_times/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/development_times/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/development_times/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/development_times/create"
      expect(response).to have_http_status(:success)
    end
  end
end
