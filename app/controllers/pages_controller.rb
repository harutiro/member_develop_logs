class PagesController < ApplicationController
  before_action :require_user_selected

  def home
    @current_avatar = current_user.current_mentor_avatar
    @total_development_time = current_user&.total_development_time || 0
    @achievement_count = current_user&.achievements&.count || 0
    @recent_development_times = current_user&.development_times&.order(start_time: :desc)&.limit(5) || []
    @recent_achievements = current_user&.achievements&.order(created_at: :desc)&.limit(5) || []
    @current_development_time = current_user&.current_development_time
    
    # 初回ユーザー判定
    if current_user.first_time_user? && !session[:tutorial_shown]
      @show_tutorial = true
      session[:tutorial_shown] = true
    end
    
    # 未表示のレベルアップ通知を確認
    unshown_notification = current_user.level_up_notifications.unshown.first
    if unshown_notification
      @new_mentor = MentorAvatar.find_by(level: unshown_notification.mentor_level)
      # 通知を表示済みにマーク
      unshown_notification.update!(shown: true)
    end
    
    # 新しいメンター獲得フラグを確認（セッションから削除する前に変数に保存）
    if session[:new_mentor_acquired] && session[:new_mentor_level]
      @new_mentor = MentorAvatar.find_by(level: session[:new_mentor_level])
      # セッションをクリア
      session.delete(:new_mentor_acquired)
      session.delete(:new_mentor_level)
    end
    
    # 初回メンター獲得の判定（セッションから削除する前に変数に保存）
    if current_user.first_mentor_acquired? && !session[:first_mentor_shown]
      @first_mentor = current_user.first_mentor
      session[:first_mentor_shown] = true
    elsif current_user.level >= 1 && !session[:first_mentor_shown]
      # レベル1以上で初回メンター獲得のセッションが設定されていない場合
      @first_mentor = current_user.first_mentor
      session[:first_mentor_shown] = true
    end
  end

  # デバッグ用：セッションをリセット
  def reset_session
    session.delete(:first_mentor_shown)
    session.delete(:new_mentor_acquired)
    session.delete(:new_mentor_level)
    session.delete(:tutorial_shown)
    # LevelUpNotificationもリセット
    current_user.level_up_notifications.update_all(shown: false)
    redirect_to root_path, notice: 'セッションをリセットしました。アニメーションが再表示されるはずです。'
  end

  # デバッグ用：テスト用のセッションを設定（レベル指定可）
  def test_animation
    level = params[:level].to_i
    if level > 0 && MentorAvatar.find_by(level: level)
      # LevelUpNotificationを作成してテスト
      current_user.level_up_notifications.create!(
        mentor_level: level,
        shown: false
      )
      redirect_to root_path, notice: "レベル#{level}のメンター紹介テストを表示します。"
    else
      redirect_to root_path, alert: '有効なレベルを指定してください。'
    end
  end
end
