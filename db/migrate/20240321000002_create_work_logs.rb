class CreateWorkLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :work_logs do |t|
      t.references :member, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
