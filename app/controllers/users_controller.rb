class UsersController < ApplicationController
  skip_before_action :require_user_selected, only: [ :select, :set, :new, :create, :index ]
  before_action :set_user, only: [ :edit, :update, :destroy, :level_up ]

  def select
    @users = User.all.includes(:development_times, :achievements)
  end

  def set
    user = User.find(params[:user_id])
    session[:user_id] = user.id
    redirect_to root_path, notice: "#{user.name}さんとしてログインしました"
  end

  def index
    @users = User.all.includes(:development_times, :achievements, :nullpo_game)
    
    # 並び替えパラメータを取得
    sort_by = params[:sort_by] || 'id'
    order = params[:order] || 'asc'
    
    # 並び替え処理
    @users = sort_users(@users, sort_by, order)
    
    # 現在の並び替え状態を保持
    @current_sort = sort_by
    @current_order = order
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to select_user_path, notice: "#{@user.name}さんを登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "#{@user.name}さんの情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user_name = @user.name
    @user.destroy
    redirect_to users_path, notice: "#{user_name}さんを削除しました。"
  end

  def level_up
    setting = LevelUpSetting.current

    if setting.level_up_condition_met?(@user)
      old_level = @user.level
      @user.update!(level: @user.level + 1)
      new_level = @user.level

      # 新しいメンターを獲得したかチェック
      new_mentor = MentorAvatar.find_by(level: new_level)
      if new_mentor
        # セッションに新しいメンター獲得フラグを保存
        session[:new_mentor_acquired] = true
        session[:new_mentor_level] = new_level
      end
      redirect_to root_path, notice: "#{@user.name}がレベルアップしました！（レベル#{old_level} → #{@user.level}）"
    else
      requirements = setting.next_level_requirements(@user)
      message = "#{@user.name}はまだレベルアップできません。"

      if requirements[:hours_remaining] > 0
        message += " 時間: あと#{requirements[:hours_remaining].round(2)}時間"
      end
      if requirements[:achievements_remaining] > 0
        message += " 達成数: あと#{requirements[:achievements_remaining]}個"
      end

      redirect_to users_path, alert: message
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def sort_users(users, sort_by, order)
    # orderパラメータを検証
    safe_order = order.to_s.downcase == 'desc' ? 'DESC' : 'ASC'
    
    case sort_by
    when 'id'
      users.order(id: safe_order.downcase)
    when 'name'
      users.order(name: safe_order.downcase)
    when 'email'
      users.order(email: safe_order.downcase)
    when 'level'
      users.order(level: safe_order.downcase)
    when 'total_development_time'
      # 開発時間の並び替え（development_timesの合計）
      users.left_joins(:development_times)
           .group('users.id')
           .order(Arel.sql("SUM(COALESCE(development_times.duration, 0)) #{safe_order}"))
    when 'created_at'
      users.order(created_at: safe_order.downcase)
    when 'nullpo_count'
      # ぬるぽ数の並び替え
      users.left_joins(:nullpo_game)
           .order(Arel.sql("COALESCE(nullpo_games.nullpo_count, 0) #{safe_order}"))
    when 'total_clicks'
      # 総クリック数の並び替え
      users.left_joins(:nullpo_game)
           .order(Arel.sql("COALESCE(nullpo_games.total_clicks, 0) #{safe_order}"))
    when 'click_power'
      # クリック力の並び替え
      users.left_joins(:nullpo_game)
           .order(Arel.sql("COALESCE(nullpo_games.click_power, 0) #{safe_order}"))
    when 'auto_clicks_per_second'
      # 自動クリックの並び替え
      users.left_joins(:nullpo_game)
           .order(Arel.sql("COALESCE(nullpo_games.auto_clicks_per_second, 0) #{safe_order}"))
    else
      users.order(id: safe_order.downcase)
    end
  end
end
