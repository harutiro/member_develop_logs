require "test_helper"

class Admin::IndexTest < ActionView::TestCase
  test "renders admin index page" do
    user = users(:one)
    mentor_avatar = mentor_avatars(:one)
    
    assign(:users, [user])
    assign(:mentor_avatars, [mentor_avatar])
    
    render
    
    assert_includes rendered, "管理画面"
    assert_includes rendered, "ユーザー管理"
    assert_includes rendered, "メンター管理"
  end
end 