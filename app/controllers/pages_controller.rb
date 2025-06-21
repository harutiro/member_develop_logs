class PagesController < ApplicationController
  before_action :require_user_selected

  def home
    @current_avatar = current_user.mentor_avatar
    @total_development_time = current_user&.total_development_time || 0
    @achievement_count = current_user&.achievements&.count || 0
    @recent_development_times = current_user&.development_times&.order(start_time: :desc)&.limit(5) || []
    @recent_achievements = current_user&.achievements&.order(created_at: :desc)&.limit(5) || []
    @current_development_time = current_user&.current_development_time
  end
end
