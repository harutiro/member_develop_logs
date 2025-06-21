class MentorAvatarsController < ApplicationController
  before_action :require_user_selected
  before_action :set_mentor_avatar, only: [:show, :edit, :update, :destroy]

  def index
    @mentor_avatars = MentorAvatar.where(user: current_user)
    @users = User.all
  end

  def current
    @mentor_avatar = current_user.mentor_avatar
  end

  def new
    @mentor_avatar = MentorAvatar.new
  end

  def create
    @mentor_avatar = MentorAvatar.new(mentor_avatar_params)
    @mentor_avatar.user = current_user
    if @mentor_avatar.save
      redirect_to mentor_avatars_path, notice: 'メンターアバターを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @mentor_avatar.update(mentor_avatar_params)
      redirect_to mentor_avatars_path, notice: 'メンターアバターを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    mentor_name = @mentor_avatar.name
    @mentor_avatar.destroy
    redirect_to mentor_avatars_path, notice: "#{mentor_name}を削除しました。"
  end

  def level_up
    user = User.find(params[:user_id])
    next_level_hours = user.level * 1
    current_hours = user.total_development_time / 3600.0
    
    if current_hours >= next_level_hours
      user.update!(level: user.level + 1)
      
      # メンターアバターもレベルアップ
      if user.mentor_avatar
        user.mentor_avatar.update!(level: user.mentor_avatar.level + 1)
      end
      
      redirect_to mentor_avatars_path, notice: "#{user.name}がレベルアップしました！（レベル#{user.level - 1} → #{user.level}）"
    else
      redirect_to mentor_avatars_path, alert: "#{user.name}はまだレベルアップできません。"
    end
  end

  private

  def set_mentor_avatar
    @mentor_avatar = MentorAvatar.where(user: current_user).find(params[:id])
  end

  def mentor_avatar_params
    params.require(:mentor_avatar).permit(:name, :description, :image, :level)
  end
end
