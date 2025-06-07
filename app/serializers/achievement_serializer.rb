class AchievementSerializer < ActiveModel::Serializer
  attributes :id, :content, :category, :points, :created_at

  belongs_to :user
end 