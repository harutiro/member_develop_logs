require 'rails_helper'

RSpec.describe "Admin", type: :request do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id
  end

  describe "GET /admin" do
    it "管理画面が表示される" do
      get admin_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("管理画面")
    end

    context "ユーザーが選択されていない場合" do
      before { session[:user_id] = nil }

      it "ユーザー選択画面にリダイレクトされる" do
        get admin_path
        expect(response).to redirect_to(select_user_path)
      end
    end
  end
end 