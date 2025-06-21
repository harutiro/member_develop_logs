class LevelUpNotification < ApplicationRecord
  belongs_to :user

  validates :mentor_level, presence: true, numericality: { greater_than: 0 }
  validates :shown, inclusion: { in: [ true, false ] }

  # 未表示の通知を取得
  scope :unshown, -> { where(shown: false) }

  # 特定のユーザーの未表示通知を取得
  scope :unshown_for_user, ->(user) { where(user: user, shown: false) }
end
