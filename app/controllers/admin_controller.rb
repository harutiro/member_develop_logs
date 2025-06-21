class AdminController < ApplicationController
  before_action :require_user_selected
  helper_method :current_user

  def index
    @users = User.all.includes(:mentor_avatar, :development_times, :achievements)
    @mentor_avatars = MentorAvatar.where(user: current_user)
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