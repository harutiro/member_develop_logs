module Api
  module V1
    class DevelopmentTimesController < BaseController
      def create
        development_time = current_user.development_times.build(development_time_params)
        if development_time.save
          current_user.update_total_development_time
          current_user.check_level_up
          render json: development_time, status: :created
        else
          render json: { errors: development_time.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        development_times = current_user.development_times.order(start_time: :desc)
        render json: development_times
      end

      def show
        development_time = current_user.development_times.find(params[:id])
        render json: development_time
      rescue ActiveRecord::RecordNotFound
        render json: { error: '記録が見つかりません' }, status: :not_found
      end

      private

      def development_time_params
        params.require(:development_time).permit(:start_time, :end_time, :notes)
      end
    end
  end
end
