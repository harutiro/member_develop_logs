class MentorAvatarSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :transformation_type, :level, :created_at

  has_many :avatar_transformations
end 