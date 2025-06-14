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
    new_level = (total_development_time / 3600) + 1 # 1時間ごとにレベルアップ
    update(level: new_level) if new_level > level
  end

  def total_development_time
    development_times.sum(:duration)
  end
end