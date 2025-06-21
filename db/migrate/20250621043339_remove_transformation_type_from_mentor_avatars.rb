class RemoveTransformationTypeFromMentorAvatars < ActiveRecord::Migration[8.0]
  def change
    remove_column :mentor_avatars, :transformation_type, :string
  end
end
