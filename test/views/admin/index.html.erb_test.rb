require "test_helper"

class AdminIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "renders admin index page" do
    post set_user_path, params: { user_id: @user.id }
    get admin_path
    
    assert_response :success
    assert_includes response.body, "管理画面"
    assert_includes response.body, "ユーザー管理"
    assert_includes response.body, "メンター管理"
  end
end 