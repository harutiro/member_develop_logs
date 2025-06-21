class AllowNullEndTimeAndDurationInDevelopmentTimes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :development_times, :end_time, true
    change_column_null :development_times, :duration, true
  end
end
