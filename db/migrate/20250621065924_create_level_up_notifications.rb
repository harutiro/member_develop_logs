class CreateLevelUpNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :level_up_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :mentor_level
      t.boolean :shown

      t.timestamps
    end
  end
end
