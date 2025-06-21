class AdminController < ApplicationController
  before_action :require_user_selected
  helper_method :current_user

  def index
    @users = User.all.includes(:development_times, :achievements)
    @mentor_avatars = MentorAvatar.order(:level)
  end

  def bulk_level_up
    setting = LevelUpSetting.current
    leveled_up_users = []
    new_mentors_acquired = []

    User.find_each do |user|
      if setting.level_up_condition_met?(user)
        old_level = user.level
        user.update!(level: user.level + 1)
        new_level = user.level

        # 新しいメンターを獲得したかチェック
        new_mentor = MentorAvatar.find_by(level: new_level)
        if new_mentor
          # LevelUpNotificationを作成（未表示状態）
          user.level_up_notifications.create!(
            mentor_level: new_level,
            shown: false
          )
          new_mentors_acquired << { user: user, mentor: new_mentor }
        end

        leveled_up_users << { user: user, old_level: old_level, new_level: user.level }
      end
    end

    if leveled_up_users.any?
      message = "レベルアップ完了！\n"
      leveled_up_users.each do |data|
        message += "・#{data[:user].name}: レベル#{data[:old_level]} → #{data[:new_level]}\n"
      end

      # 新しいメンターを獲得したユーザーがいる場合、セッションに保存
      if new_mentors_acquired.any?
        # 現在のユーザーが新しいメンターを獲得した場合、セッションにフラグを設定
        current_user_new_mentor = new_mentors_acquired.find { |nm| nm[:user].id == current_user.id }
        if current_user_new_mentor
          session[:new_mentor_acquired] = true
          session[:new_mentor_level] = current_user_new_mentor[:mentor].level
        end
      end

      redirect_to admin_path, notice: message
    else
      redirect_to admin_path, alert: "レベルアップ条件を満たしているユーザーがいません。"
    end
  end

  private

  def require_user_selected
    unless session[:user_id]
      redirect_to select_user_path, alert: "ユーザーを選択してください"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
