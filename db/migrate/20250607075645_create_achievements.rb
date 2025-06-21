class CreateAchievements < ActiveRecord::Migration[8.0]
  def change
    create_table :achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.string :category, null: false
      t.integer :points, default: 0, null: false

      t.timestamps
    end
    add_index :achievements, [ :user_id, :created_at ]
    add_index :achievements, :category
  end
end
