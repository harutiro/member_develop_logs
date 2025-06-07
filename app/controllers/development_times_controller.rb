class DevelopmentTimesController < ApplicationController
  before_action :require_user_selected
  before_action :set_development_time, only: [:show]

  def index
    @development_times = current_user.development_times.order(start_time: :desc)
    @total_development_time = current_user.total_development_time
  end

  def show
  end

  def new
    @development_time = current_user.development_times.new
  end

  def create
    @development_time = current_user.development_times.new(development_time_params)
    if @development_time.save
      redirect_to development_times_path, notice: '開発時間を記録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_development_time
    @development_time = current_user.development_times.find(params[:id])
  end

  def development_time_params
    params.require(:development_time).permit(:start_time, :end_time, :duration, :notes)
  end
end
