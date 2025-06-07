class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_user
  before_action :require_user_selected

  private

  def set_current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user
    @current_user
  end
  helper_method :current_user

  def require_user_selected
    unless current_user
      redirect_to select_user_path, alert: "ユーザーを選択してください"
    end
  end
end
