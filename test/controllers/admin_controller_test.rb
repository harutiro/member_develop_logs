require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:one)
    post set_user_path, params: { user_id: user.id }
    get admin_url
    assert_response :success
  end

  test "should redirect to select user when no user selected" do
    get admin_url
    assert_redirected_to select_user_path
  end
end 