require 'rails_helper'

RSpec.describe "admin/index", type: :view do
  let(:user) { create(:user) }
  let(:mentor_avatar) { create(:mentor_avatar, user: user) }

  before do
    assign(:users, [ user ])
    assign(:mentor_avatars, [ mentor_avatar ])
    allow(view).to receive(:current_user).and_return(user)
    render
  end

  it "管理画面のタイトルが表示される" do
    expect(rendered).to include("管理画面")
  end

  it "ユーザー管理へのリンクが表示される" do
    expect(rendered).to include("ユーザー管理")
    expect(rendered).to include(users_path)
  end

  it "メンター管理へのリンクが表示される" do
    expect(rendered).to include("メンター管理")
    expect(rendered).to include(mentor_avatars_path)
  end

  it "システム状況が表示される" do
    expect(rendered).to include("システム状況")
    expect(rendered).to include("ユーザー数")
    expect(rendered).to include("メンター数")
  end
end
