class MentorAvatar < ApplicationRecord
  belongs_to :user
  has_many :avatar_transformations, dependent: :destroy
  has_one_attached :image

  include Rails.application.routes.url_helpers

  validates :name, presence: true
  validates :description, presence: true
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

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(image)
    else
      '/assets/default.png'
    end
  end

  def self.transform_based_on_achievements(total_hours, achievement_count)
    case
    when total_hours >= 100 && achievement_count >= 50
      create!(
        name: "マスター",
        description: "プログラミングの達人",
        transformation_type: "master",
        level: 5
      )
    when total_hours >= 50 && achievement_count >= 25
      create!(
        name: "賢者",
        description: "コードの賢者",
        transformation_type: "sage",
        level: 4
      )
    when total_hours >= 20 && achievement_count >= 10
      create!(
        name: "クール",
        description: "クールなプログラマー",
        transformation_type: "cool",
        level: 3
      )
    else
      create!(
        name: "初心者",
        description: "プログラミング初心者",
        transformation_type: "beginner",
        level: 1
      )
    end
  end
end
