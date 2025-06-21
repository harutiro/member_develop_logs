module Api
  module V1
    class MentorAvatarsController < BaseController
      def show
        avatar = MentorAvatar.current_avatar
        if avatar
          render json: avatar
        else
          render json: { error: "アバターが見つかりません" }, status: :not_found
        end
      end

      def index
        avatars = MentorAvatar.order(created_at: :desc)
        render json: avatars
      end
    end
  end
end
