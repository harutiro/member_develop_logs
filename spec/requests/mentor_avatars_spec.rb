require 'rails_helper'

RSpec.describe "MentorAvatars", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/mentor_avatars/show"
      expect(response).to have_http_status(:success)
    end
  end
end
