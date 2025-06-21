class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :members, :name, unique: true
  end
end
