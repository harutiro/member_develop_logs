class CreateAvatarTransformations < ActiveRecord::Migration[8.0]
  def change
    create_table :avatar_transformations do |t|
      t.references :mentor_avatar, null: false, foreign_key: true
      t.string :trigger_type, null: false
      t.integer :trigger_value, null: false
      t.datetime :transformation_date, null: false

      t.timestamps
    end
    add_index :avatar_transformations, [ :mentor_avatar_id, :transformation_date ]
    add_index :avatar_transformations, :trigger_type
  end
end
