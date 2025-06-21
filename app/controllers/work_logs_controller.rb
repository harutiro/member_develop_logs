class WorkLogsController < ApplicationController
  before_action :set_work_log, only: [ :edit, :update, :destroy ]

  def index
    @members = Member.all

    # メンバーが存在しない場合は、メンバー管理ページにリダイレクト
    if @members.empty?
      redirect_to members_path, alert: "メンバーを追加してください"
      return
    end

    # セッションから選択されたメンバーIDを取得、またはURLパラメータから取得
    selected_member_id = params[:member_id] || session[:selected_member_id]

    # メンバーを取得（存在しない場合はnilを設定）
    @selected_member = Member.find_by(id: selected_member_id)

    # メンバーが選択されている場合のみセッションに保存
    if @selected_member
      session[:selected_member_id] = @selected_member.id
    end

    # 作業中のログを取得
    @active_work_log = WorkLog.find_by(member: @selected_member, end_time: nil) if @selected_member

    # 今日から2週間前までのデータを取得
    end_date = Date.current
    start_date = end_date - 13.days

    # 2週間分の日付を生成
    @date_range = (start_date..end_date).to_a

    # 選択されたメンバーの作業ログを取得
    if @selected_member
      @selected_member_logs = WorkLog.where(member: @selected_member)
        .where(start_time: start_date.beginning_of_day..end_date.end_of_day)
        .order(start_time: :desc)
    end

    # 全メンバーの作業ログを取得（グラフ用）
    @work_logs = WorkLog.where(start_time: start_date.beginning_of_day..end_date.end_of_day)
      .order(start_time: :desc)

    # メンバーごとの日次データを計算
    @daily_data = {}
    @members.each do |member|
      member_logs = @work_logs.where(member: member)
      daily_logs = member_logs.group_by { |log| log.start_time.to_date }
        .transform_values { |logs| logs.sum(&:duration) }

      # 2週間分の日付に対して、データがない日は0を設定
      @daily_data[member.name] = @date_range.each_with_object({}) do |date, hash|
        hash[date.to_s] = daily_logs[date] || 0
      end
    end
  end

  def start_work
    Rails.logger.info "Starting work for member_id: #{params[:member_id]}"

    # 既存の作業中のログがないか確認
    existing_log = WorkLog.find_by(member_id: params[:member_id], end_time: nil)
    if existing_log
      Rails.logger.info "Found existing active log: #{existing_log.id}"
      redirect_to work_logs_path(member_id: params[:member_id]), notice: "既に作業中のログが存在します"
      return
    end

    @work_log = WorkLog.new(member_id: params[:member_id], start_time: Time.current)

    if @work_log.save
      Rails.logger.info "Successfully created work log: #{@work_log.id}"
      redirect_to work_logs_path(member_id: params[:member_id]), notice: "作業を開始しました"
    else
      Rails.logger.error "Failed to create work log: #{@work_log.errors.full_messages.join(', ')}"
      redirect_to work_logs_path(member_id: params[:member_id]), alert: "作業の開始に失敗しました"
    end
  end

  def end_work
    Rails.logger.info "Ending work for member_id: #{params[:member_id]}"

    @work_log = WorkLog.find_by(member_id: params[:member_id], end_time: nil)

    if @work_log&.update(end_time: Time.current)
      Rails.logger.info "Successfully ended work log: #{@work_log.id}"
      redirect_to work_logs_path(member_id: params[:member_id]), notice: "作業を終了しました"
    else
      Rails.logger.error "Failed to end work log"
      redirect_to work_logs_path(member_id: params[:member_id]), alert: "作業の終了に失敗しました"
    end
  end

  def new
    @work_log = WorkLog.new
    @members = Member.all
  end

  def create
    @work_log = WorkLog.new(work_log_params)

    if @work_log.save
      redirect_to work_logs_path(member_id: @work_log.member_id), notice: "作業時間を記録しました"
    else
      @members = Member.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @members = Member.all
  end

  def update
    if @work_log.update(work_log_params)
      redirect_to work_logs_path(member_id: @work_log.member_id), notice: "作業ログを更新しました"
    else
      @members = Member.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    member_id = @work_log.member_id
    @work_log.destroy
    redirect_to work_logs_path(member_id: member_id), notice: "作業ログを削除しました"
  end

  private

  def set_work_log
    @work_log = WorkLog.find(params[:id])
  end

  def work_log_params
    params.require(:work_log).permit(:member_id, :start_time, :end_time)
  end
end
