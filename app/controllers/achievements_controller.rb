class AchievementsController < ApplicationController
  before_action :require_user_selected
  before_action :set_achievement, only: [:show]

  def index
    @achievements = current_user.achievements.order(created_at: :desc)
  end

  def show
  end

  def new
    @achievement = current_user.achievements.new
  end

  def create
    @achievement = current_user.achievements.new(achievement_params)
    if @achievement.save
      redirect_to achievements_path, notice: 'できたことを記録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_achievement
    @achievement = current_user.achievements.find(params[:id])
  end

  def achievement_params
    params.require(:achievement).permit(:content, :category)
  end
end
