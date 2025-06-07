class MentorAvatarsController < ApplicationController
  before_action :require_user_selected
  before_action :set_mentor_avatar, only: [:show]

  def index
    @mentor_avatars = MentorAvatar.where(user: current_user)
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

  private

  def set_mentor_avatar
    @mentor_avatar = current_user.mentor_avatar
  end

  def mentor_avatar_params
    params.require(:mentor_avatar).permit(:name, :description, :image, :transformation_type, :level)
  end
end
