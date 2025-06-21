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
    setting = LevelUpSetting.current
    
    if setting.level_up_condition_met?(user)
      user.update!(level: user.level + 1)
      
      # メンターアバターもレベルアップ
      if user.mentor_avatar
        user.mentor_avatar.update!(level: user.mentor_avatar.level + 1)
      end
      
      redirect_to mentor_avatars_path, notice: "#{user.name}がレベルアップしました！（レベル#{user.level - 1} → #{user.level}）"
    else
      requirements = setting.next_level_requirements(user)
      message = "#{user.name}はまだレベルアップできません。"
      
      if requirements[:hours_remaining] > 0
        message += " 時間: あと#{requirements[:hours_remaining].round(2)}時間"
      end
      if requirements[:achievements_remaining] > 0
        message += " 達成数: あと#{requirements[:achievements_remaining]}個"
      end
      
      redirect_to mentor_avatars_path, alert: message
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
