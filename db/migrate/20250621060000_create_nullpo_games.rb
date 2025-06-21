class CreateNullpoGames < ActiveRecord::Migration[8.0]
  def change
    create_table :nullpo_games do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :nullpo_count, default: 0, null: false
      t.bigint :total_clicks, default: 0, null: false
      t.bigint :auto_clicks_per_second, default: 0, null: false
      t.bigint :click_power, default: 1, null: false
      t.datetime :last_auto_click_at
      t.timestamps
    end

    add_index :nullpo_games, :nullpo_count
    add_index :nullpo_games, :auto_clicks_per_second
  end
end
