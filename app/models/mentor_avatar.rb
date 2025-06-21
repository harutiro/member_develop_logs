class MentorAvatar < ApplicationRecord
  belongs_to :user
  has_many :avatar_transformations, dependent: :destroy
  has_one_attached :image

  include Rails.application.routes.url_helpers

  validates :name, presence: true
  validates :description, presence: true
  validates :level, presence: true, numericality: { greater_than: 0 }

  def self.current_avatar
    order(created_at: :desc).first
  end

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(image)
    else
      '/assets/default.png'
    end
  rescue => e
    # ホスト情報が不足している場合のフォールバック
    '/assets/default.png'
  end

  def update_by_achievement(total_development_time, achievement_count)
    # レベルアップ設定に基づいてメンターアバターを更新
    setting = LevelUpSetting.current
    
    # ユーザーのレベルアップ判定
    if setting.level_up_condition_met?(user)
      update!(level: level + 1)
    end
  end

  def self.transform_based_on_achievements(total_hours, achievement_count)
    case
    when total_hours >= 100 && achievement_count >= 50
      create!(
        name: "マスター",
        description: "プログラミングの達人",
        level: 5
      )
    when total_hours >= 50 && achievement_count >= 25
      create!(
        name: "賢者",
        description: "コードの賢者",
        level: 4
      )
    when total_hours >= 20 && achievement_count >= 10
      create!(
        name: "クール",
        description: "クールなプログラマー",
        level: 3
      )
    else
      create!(
        name: "初心者",
        description: "プログラミング初心者",
        level: 1
      )
    end
  end
end
