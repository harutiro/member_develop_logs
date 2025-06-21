module Api
  module V1
    class AchievementsController < BaseController
      def create
        achievement = current_user.achievements.build(achievement_params)
        if achievement.save
          update_mentor_avatar
          render json: achievement, status: :created
        else
          render json: { errors: achievement.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        achievements = current_user.achievements.order(created_at: :desc)
        render json: achievements
      end

      def show
        achievement = current_user.achievements.find(params[:id])
        render json: achievement
      rescue ActiveRecord::RecordNotFound
        render json: { error: "記録が見つかりません" }, status: :not_found
      end

      private

      def achievement_params
        params.require(:achievement).permit(:content, :category)
      end

      def update_mentor_avatar
        total_hours = current_user.total_development_time / 3600
        achievement_count = current_user.achievements.count
        MentorAvatar.transform_based_on_achievements(total_hours, achievement_count)
      end
    end
  end
end
