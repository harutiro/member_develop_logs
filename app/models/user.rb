class User < ApplicationRecord
  has_many :development_times, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_one :nullpo_game, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :total_development_time, numericality: { greater_than_or_equal_to: 0 }
  validates :level, numericality: { greater_than: 0 }

  def update_total_development_time
    total = development_times.sum(:duration)
    update(total_development_time: total)
  end

  # 自動レベルアップは無効化（管理者による一斉レベルアップのみ）
  def check_level_up
    # 自動レベルアップは行わない
    # 管理者が一斉レベルアップボタンで実行する
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

  # レベルアップ可能かどうかを判定（自動実行はしない）
  def can_level_up?
    setting = LevelUpSetting.current
    setting.level_up_condition_met?(self)
  end

  # 現在のメンターアバター（自分のレベル以下で最大のもの）
  def current_mentor_avatar
    MentorAvatar.where('level <= ?', level).order(level: :desc).first
  end

  # 集めたメンター（自分のレベル以下の全メンター）
  def collected_mentor_avatars
    MentorAvatar.where('level <= ?', level).order(:level)
  end

  # 新しいメンターを獲得したかどうかを判定
  def has_new_mentor?
    new_mentor = MentorAvatar.find_by(level: level)
    new_mentor.present?
  end

  # 新しく獲得したメンターを取得
  def newly_acquired_mentor
    MentorAvatar.find_by(level: level)
  end

  # 初めてメンターを獲得したかどうかを判定
  def first_mentor_acquired?
    # レベル1以上で、かつメンターが存在する場合
    level >= 1 && MentorAvatar.where('level <= ?', level).exists?
  end

  # 初回メンターを取得
  def first_mentor
    MentorAvatar.where('level <= ?', level).order(:level).first
  end

  # ぬるぽゲームを作成または取得
  def nullpo_game_or_create!
    nullpo_game || create_nullpo_game!
  end

  # ぬるぽゲームを作成
  def create_nullpo_game!
    return nullpo_game if nullpo_game
    
    create_nullpo_game(
      nullpo_count: 0,
      total_clicks: 0,
      auto_clicks_per_second: 0,
      click_power: level
    )
  end
end