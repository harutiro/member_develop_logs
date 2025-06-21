require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should get index when user is selected" do
    post set_user_path, params: { user_id: @user.id }
    get admin_path
    assert_response :success
    assert_select "h1", "管理画面"
  end

  test "should redirect to select user when no user selected" do
    get admin_path
    assert_redirected_to select_user_path
    assert_equal "ユーザーを選択してください", flash[:alert]
  end

  test "should show users and mentor avatars on index" do
    post set_user_path, params: { user_id: @user.id }
    get admin_path
    assert_response :success
    assert_select "h3", "ユーザー管理"
    assert_select "h3", "メンター管理"
  end

  test "should perform bulk level up" do
    post set_user_path, params: { user_id: @user.id }
    post bulk_level_up_admin_path
    assert_redirected_to admin_path
  end

  test "should require user selection for bulk level up" do
    post bulk_level_up_admin_path
    assert_redirected_to select_user_path
  end
end
