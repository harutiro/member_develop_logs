class AllowNullEndTimeInWorkLogs < ActiveRecord::Migration[7.0]
  def change
    change_column_null :work_logs, :end_time, true
  end
end
