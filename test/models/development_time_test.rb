require "test_helper"

class DevelopmentTimeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @development_time = development_times(:one)
  end

  test "should be valid" do
    assert @development_time.valid?
  end

  test "user should be present" do
    @development_time.user = nil
    assert_not @development_time.valid?
  end

  test "start_time should be present" do
    @development_time.start_time = nil
    assert_not @development_time.valid?
  end

  test "end_time should be after start_time" do
    @development_time.start_time = Time.current
    @development_time.end_time = 1.hour.ago
    assert_not @development_time.valid?
  end

  test "duration should be calculated correctly" do
    start_time = Time.current
    end_time = start_time + 2.hours
    @development_time.start_time = start_time
    @development_time.end_time = end_time
    @development_time.save
    assert_equal 7200, @development_time.duration # 2 hours in seconds
  end

  test "should belong to user" do
    assert_respond_to @development_time, :user
  end

  test "should have notes" do
    @development_time.notes = "テスト用の開発時間記録"
    assert @development_time.valid?
  end

  test "can have null end_time" do
    @development_time.end_time = nil
    assert @development_time.valid?
  end

  test "can have null duration" do
    @development_time.duration = nil
    assert @development_time.valid?
  end
end
