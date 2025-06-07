class CreateMentorAvatars < ActiveRecord::Migration[8.0]
  def change
    create_table :mentor_avatars do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :image_url, null: false
      t.string :transformation_type, null: false
      t.integer :level, default: 1, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :mentor_avatars, :transformation_type
    add_index :mentor_avatars, :level
  end
end
