class CreateLevelUpSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :level_up_settings do |t|
      t.string :name, null: false
      t.text :description
      t.integer :hours_per_level, default: 1, null: false
      t.integer :achievements_per_level, default: 0, null: false
      t.boolean :enabled, default: true, null: false
      t.timestamps
    end

    add_index :level_up_settings, :enabled
  end
end
