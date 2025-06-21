class RemoveUserIdFromMentorAvatars < ActiveRecord::Migration[8.0]
  def change
    remove_reference :mentor_avatars, :user, foreign_key: true
  end
end
