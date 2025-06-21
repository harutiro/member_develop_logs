require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "level should be greater than or equal to 1" do
    @user.level = 0
    assert_not @user.valid?
    @user.level = 1
    assert @user.valid?
  end

  test "total_development_time should be greater than or equal to 0" do
    @user.total_development_time = -1
    assert_not @user.valid?
    @user.total_development_time = 0
    assert @user.valid?
  end

  test "should have many development_times" do
    assert_respond_to @user, :development_times
  end

  test "should have many achievements" do
    assert_respond_to @user, :achievements
  end

  test "should have many level_up_notifications" do
    assert_respond_to @user, :level_up_notifications
  end

  test "should have one nullpo_game" do
    assert_respond_to @user, :nullpo_game
  end
end
