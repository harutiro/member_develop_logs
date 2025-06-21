class DevelopmentTimesController < ApplicationController
  before_action :require_user_selected
  before_action :set_development_time, only: [ :show ]

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
      redirect_to development_times_path, notice: "開発時間を記録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def start_development
    # 既に進行中の開発時間がある場合は終了させる
    if current_user.current_development_time
      current_user.current_development_time.update!(end_time: Time.current)
    end

    @development_time = current_user.development_times.create!(
      start_time: Time.current,
      notes: params[:notes]
    )

    redirect_to root_path, notice: "開発を開始しました！"
  end

  def end_development
    current_development = current_user.current_development_time

    if current_development
      current_development.update!(end_time: Time.current)
      duration = (current_development.end_time - current_development.start_time).to_i
      current_development.update!(duration: duration)

      redirect_to root_path, notice: "開発を終了しました。開発時間: #{duration / 60}分"
    else
      redirect_to root_path, alert: "進行中の開発が見つかりません。"
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
