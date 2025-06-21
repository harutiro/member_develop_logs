class PagesController < ApplicationController
  before_action :require_user_selected

  def home
    @current_avatar = current_user.current_mentor_avatar
    @total_development_time = current_user&.total_development_time || 0
    @achievement_count = current_user&.achievements&.count || 0
    @recent_development_times = current_user&.development_times&.order(start_time: :desc)&.limit(5) || []
    @recent_achievements = current_user&.achievements&.order(created_at: :desc)&.limit(5) || []
    @current_development_time = current_user&.current_development_time
    
    # セッションから新しいメンター獲得フラグを確認
    if session[:new_mentor_acquired] && session[:new_mentor_level]
      @new_mentor = MentorAvatar.find_by(level: session[:new_mentor_level])
      # セッションをクリア
      session.delete(:new_mentor_acquired)
      session.delete(:new_mentor_level)
    end
    
    # 初回メンター獲得の判定
    if current_user.first_mentor_acquired? && !session[:first_mentor_shown]
      @first_mentor = current_user.first_mentor
      session[:first_mentor_shown] = true
    end
  end
end
