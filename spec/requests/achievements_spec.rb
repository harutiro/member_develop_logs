require 'rails_helper'

RSpec.describe "Achievements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/achievements/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/achievements/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/achievements/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/achievements/create"
      expect(response).to have_http_status(:success)
    end
  end

end
