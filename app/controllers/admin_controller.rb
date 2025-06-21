class AdminController < ApplicationController
  before_action :require_user_selected
  helper_method :current_user

  def index
    @users = User.all.includes(:mentor_avatars, :development_times, :achievements)
    @mentor_avatars = current_user.mentor_avatars.order(:created_at)
  end

  def bulk_level_up
    setting = LevelUpSetting.current
    leveled_up_users = []
    
    User.find_each do |user|
      if setting.level_up_condition_met?(user)
        old_level = user.level
        user.update!(level: user.level + 1)
        
        # メンターアバターもレベルアップ
        if user.mentor_avatar
          user.mentor_avatar.update!(level: user.mentor_avatar.level + 1)
        end
        
        leveled_up_users << { user: user, old_level: old_level, new_level: user.level }
      end
    end
    
    if leveled_up_users.any?
      message = "レベルアップ完了！\n"
      leveled_up_users.each do |data|
        message += "・#{data[:user].name}: レベル#{data[:old_level]} → #{data[:new_level]}\n"
      end
      redirect_to admin_path, notice: message
    else
      redirect_to admin_path, alert: "レベルアップ条件を満たしているユーザーがいません。"
    end
  end

  private

  def require_user_selected
    unless session[:user_id]
      redirect_to select_user_path, alert: 'ユーザーを選択してください'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end 