class MentorAvatarsController < ApplicationController
  before_action :require_user_selected
  before_action :set_mentor_avatar, only: [ :show, :edit, :update, :destroy ]

  def index
    @mentor_avatars = MentorAvatar.order(:level)
    @users = User.all
  end

  def current
    @mentor_avatar = current_user.current_mentor_avatar
  end

  def new
    @mentor_avatar = MentorAvatar.new
  end

  def create
    @mentor_avatar = MentorAvatar.new(mentor_avatar_params)
    if @mentor_avatar.save
      redirect_to mentor_avatars_path, notice: "メンターアバターを登録しました。"
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
      redirect_to mentor_avatars_path, notice: "メンターアバターを更新しました。"
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
      old_level = user.level
      user.update!(level: user.level + 1)

      # ユーザーレベルに基づいて新しいメンターを獲得
      new_level = user.level
      case new_level
      when 2
        user.mentor_avatars.create!(
          name: "クール",
          description: "クールなプログラマー",
          level: 2
        )
      when 3
        user.mentor_avatars.create!(
          name: "賢者",
          description: "コードの賢者",
          level: 3
        )
      when 4
        user.mentor_avatars.create!(
          name: "マスター",
          description: "プログラミングの達人",
          level: 4
        )
      when 5
        user.mentor_avatars.create!(
          name: "伝説",
          description: "伝説のプログラマー",
          level: 5
        )
      end

      redirect_to mentor_avatars_path, notice: "#{user.name}がレベルアップしました！（レベル#{old_level} → #{user.level}）"
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
    @mentor_avatar = MentorAvatar.find(params[:id])
  end

  def mentor_avatar_params
    params.require(:mentor_avatar).permit(:name, :description, :image, :level)
  end
end
