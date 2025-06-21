require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    context "ユーザーが選択されている場合" do
      before do
        session[:user_id] = user.id
      end

      it "管理画面が表示される" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "@usersが設定される" do
        get :index
        expect(assigns(:users)).to eq([user])
      end

      it "@mentor_avatarsが設定される" do
        mentor_avatar = create(:mentor_avatar, user: user)
        get :index
        expect(assigns(:mentor_avatars)).to eq([mentor_avatar])
      end
    end

    context "ユーザーが選択されていない場合" do
      it "ユーザー選択画面にリダイレクトされる" do
        get :index
        expect(response).to redirect_to(select_user_path)
      end
    end
  end
end 