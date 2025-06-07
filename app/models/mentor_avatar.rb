class MentorAvatar < ApplicationRecord
  has_many :avatar_transformations, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :transformation_type, presence: true
  validates :level, presence: true, numericality: { greater_than: 0 }

  TRANSFORMATION_TYPES = %w[
    cool
    sage
    master
    exhausted
    buggy
    sleeping
    surprise
  ].freeze

  validates :transformation_type, inclusion: { in: TRANSFORMATION_TYPES }

  def self.current_avatar
    order(created_at: :desc).first
  end

  def self.transform_based_on_achievements(total_hours, achievement_count)
    case
    when total_hours >= 100 && achievement_count >= 50
      create!(
        name: "マスター",
        description: "プログラミングの達人",
        image_url: "master.png",
        transformation_type: "master",
        level: 5
      )
    when total_hours >= 50 && achievement_count >= 25
      create!(
        name: "賢者",
        description: "コードの賢者",
        image_url: "sage.png",
        transformation_type: "sage",
        level: 4
      )
    when total_hours >= 20 && achievement_count >= 10
      create!(
        name: "クール",
        description: "クールなプログラマー",
        image_url: "cool.png",
        transformation_type: "cool",
        level: 3
      )
    else
      create!(
        name: "初心者",
        description: "プログラミング初心者",
        image_url: "beginner.png",
        transformation_type: "beginner",
        level: 1
      )
    end
  end
end
