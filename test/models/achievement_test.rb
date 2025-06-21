require "test_helper"

class AchievementTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @achievement = achievements(:one)
  end

  test "should be valid" do
    assert @achievement.valid?
  end

  test "user should be present" do
    @achievement.user = nil
    assert_not @achievement.valid?
  end

  test "content should be present" do
    @achievement.content = "   "
    assert_not @achievement.valid?
  end

  test "category should be present" do
    @achievement.category = "   "
    assert_not @achievement.valid?
  end

  test "points should be greater than or equal to 0" do
    @achievement.points = -1
    assert_not @achievement.valid?
    @achievement.points = 0
    assert @achievement.valid?
  end

  test "should belong to user" do
    assert_respond_to @achievement, :user
  end

  test "should have default points of 0" do
    new_achievement = Achievement.new(
      user: @user,
      content: "テスト実績",
      category: "test"
    )
    assert_equal 0, new_achievement.points
  end

  test "should be searchable by category" do
    assert_respond_to Achievement, :where
    achievements = Achievement.where(category: @achievement.category)
    assert_includes achievements, @achievement
  end

  test "should be ordered by created_at" do
    assert_respond_to @achievement.user.achievements, :order
  end
end
