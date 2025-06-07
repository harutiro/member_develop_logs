class RemoveImageUrlFromMentorAvatars < ActiveRecord::Migration[6.0]
  def change
    remove_column :mentor_avatars, :image_url, :string
  end
end
