class MentorAvatarsController < ApplicationController
  before_action :require_user_selected
  before_action :set_mentor_avatar, only: [:show]

  def index
    @mentor_avatar = current_user.mentor_avatar
    @transformations = @mentor_avatar.avatar_transformations.order(created_at: :desc)
  end

  def show
  end

  private

  def set_mentor_avatar
    @mentor_avatar = current_user.mentor_avatar
  end
end
