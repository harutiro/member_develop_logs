class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :total_development_time, default: 0, null: false
      t.integer :level, default: 1, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
