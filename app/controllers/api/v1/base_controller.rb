module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_user

      private

      def authenticate_user
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        begin
          @decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
          @current_user = User.find(@decoded['user_id'])
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          render json: { error: '認証に失敗しました' }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end
    end
  end
end 