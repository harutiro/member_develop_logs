class User < ApplicationRecord
  has_one :mentor_avatar, dependent: :destroy
  has_many :development_times, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :total_development_time, numericality: { greater_than_or_equal_to: 0 }
  validates :level, numericality: { greater_than: 0 }

  def update_total_development_time
    total = development_times.sum(:duration)
    update(total_development_time: total)
  end

  def check_level_up
    setting = LevelUpSetting.current
    return unless setting.level_up_condition_met?(self)
    
    new_level = level + 1
    update(level: new_level)
    
    # メンターアバターもレベルアップ
    if mentor_avatar
      mentor_avatar.update!(level: mentor_avatar.level + 1)
    end
  end

  def total_development_time
    development_times.sum(:duration)
  end

  def current_development_time
    development_times.where(end_time: nil).first
  end

  def next_level_requirements
    setting = LevelUpSetting.current
    setting.next_level_requirements(self)
  end
end