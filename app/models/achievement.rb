class Achievement < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :category, presence: true

  CATEGORIES = %w[
    bug_fix
    feature_implementation
    learning
    project_completion
    code_review
    other
  ].freeze

  validates :category, inclusion: { in: CATEGORIES }

  # 自動レベルアップは無効化（管理者による一斉レベルアップのみ）
  # after_create :update_user_level

  # private

  # def update_user_level
  #   user.check_level_up
  # end
end
