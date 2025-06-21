require "test_helper"

class MentorAvatarTest < ActiveSupport::TestCase
  def setup
    @mentor_avatar = mentor_avatars(:one)
  end

  test "should be valid" do
    assert @mentor_avatar.valid?
  end

  test "name should be present" do
    @mentor_avatar.name = "   "
    assert_not @mentor_avatar.valid?
  end

  test "description should be present" do
    @mentor_avatar.description = "   "
    assert_not @mentor_avatar.valid?
  end

  test "level should be greater than or equal to 1" do
    @mentor_avatar.level = 0
    assert_not @mentor_avatar.valid?
    @mentor_avatar.level = 1
    assert @mentor_avatar.valid?
  end

  test "should have many avatar_transformations" do
    assert_respond_to @mentor_avatar, :avatar_transformations
  end

  test "should have one attached image" do
    assert_respond_to @mentor_avatar, :image
  end

  test "should order by level" do
    mentor_avatar2 = mentor_avatars(:two)
    assert_equal [ @mentor_avatar, mentor_avatar2 ], MentorAvatar.order(:level)
  end

  test "should find by level" do
    found_mentor = MentorAvatar.find_by(level: @mentor_avatar.level)
    assert_equal @mentor_avatar, found_mentor
  end
end
