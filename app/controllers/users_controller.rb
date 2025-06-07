class UsersController < ApplicationController
  skip_before_action :require_user_selected, only: [:select, :set]

  def select
    @users = User.all
  end

  def set
    user = User.find(params[:user_id])
    session[:user_id] = user.id
    redirect_to root_path, notice: "#{user.name}さんとしてログインしました"
  end
end 