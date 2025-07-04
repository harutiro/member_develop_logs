class NullpoGame < ApplicationRecord
  belongs_to :user

  validates :nullpo_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_clicks, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :auto_clicks_per_second, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :click_power, presence: true, numericality: { greater_than: 0 }

  # 全ユーザーの合計クリック数を取得
  def self.total_clicks_all_users
    sum(:total_clicks)
  end

  # 全ユーザーの合計ぬるぽ数を取得
  def self.total_nullpo_count_all_users
    sum(:nullpo_count)
  end

  def self.find_or_create_for_user(user)
    find_or_create_by(user: user) do |game|
      game.nullpo_count = 0
      game.total_clicks = 0
      game.auto_clicks_per_second = 0
      game.click_power = 1
    end
  end

  def click!
    increment!(:nullpo_count, click_power)
    increment!(:total_clicks)
    update_auto_click_power!
  rescue => e
    Rails.logger.error "ぬるぽクリックエラー: #{e.message}"
    raise e
  end

  def auto_click!
    return if auto_clicks_per_second <= 0

    # 最後の自動クリックから1秒以上経過しているかチェック
    if last_auto_click_at.nil? || last_auto_click_at < 1.second.ago
      clicks_to_add = auto_clicks_per_second
      increment!(:nullpo_count, clicks_to_add)
      update!(last_auto_click_at: Time.current)
      Rails.logger.info "自動クリック実行: #{clicks_to_add}個追加"
    end
  rescue => e
    Rails.logger.error "自動クリックエラー: #{e.message}"
  end

  def update_auto_click_power!
    # ユーザーのレベルに基づいてクリック力を更新
    self.click_power = user.level

    # メンターアバターに基づいて自動クリック力を更新
    mentor = user.current_mentor_avatar
    if mentor
      self.auto_clicks_per_second = mentor.level * 2
    else
      self.auto_clicks_per_second = 0
    end

    save!
  rescue => e
    Rails.logger.error "パワー更新エラー: #{e.message}"
    # エラーが発生してもゲームを続行できるようにする
  end

  def formatted_nullpo_count
    nullpo_count.to_s
  end

  def formatted_auto_clicks_per_second
    "#{auto_clicks_per_second}/s"
  end
end
