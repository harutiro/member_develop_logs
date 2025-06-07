class CreateDevelopmentTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :development_times do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :duration, null: false
      t.text :notes

      t.timestamps
    end
    add_index :development_times, [:user_id, :start_time]
  end
end
