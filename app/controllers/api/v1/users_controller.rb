module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_user, only: [:create]

      def create
        user = User.new(user_params)
        if user.save
          token = generate_token(user)
          render json: { user: user, token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: current_user
      end

      def update
        if current_user.update(user_params)
          render json: current_user
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def generate_token(user)
        JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
      end
    end
  end
end
