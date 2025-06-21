class LevelUpSetting < ApplicationRecord
  validates :name, presence: true
  validates :hours_per_level, presence: true, numericality: { greater_than: 0 }
  validates :achievements_per_level, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :disable_other_settings, if: :enabled_changed_to_true?

  def self.current
    where(enabled: true).first || create_default
  end

  def self.create_default
    create!(
      name: "デフォルト設定",
      description: "1時間ごとにレベルアップ",
      hours_per_level: 1,
      achievements_per_level: 0,
      enabled: true
    )
  end

  def level_up_condition_met?(user)
    current_hours = user.total_development_time / 3600.0
    current_achievements = user.achievements.count

    hours_condition = current_hours >= (user.level * hours_per_level)
    achievements_condition = current_achievements >= (user.level * achievements_per_level)

    hours_condition && achievements_condition
  end

  def next_level_requirements(user)
    next_level_hours = user.level * hours_per_level
    next_level_achievements = user.level * achievements_per_level

    current_hours = user.total_development_time / 3600.0
    current_achievements = user.achievements.count

    {
      hours_required: next_level_hours,
      hours_current: current_hours,
      hours_remaining: [ next_level_hours - current_hours, 0 ].max,
      achievements_required: next_level_achievements,
      achievements_current: current_achievements,
      achievements_remaining: [ next_level_achievements - current_achievements, 0 ].max
    }
  end

  private

  def enabled_changed_to_true?
    enabled_changed? && enabled?
  end

  def disable_other_settings
    LevelUpSetting.where.not(id: id).update_all(enabled: false)
  end
end
