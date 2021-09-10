# frozen_string_literal: true

module Api
  module V1
    class AuthenticatedController < BaseController
      before_action :authorize_user!

      def current_user
        @current_user
      end

      def current_session
        @current_session
      end

      private

      def authorize_user!
          @tv = UserSessionValidator.new
          
          begin
          token = request.headers['HTTP_AUTHENTICATION_TOKEN'] || request.headers['Authentication_Token']
          platform = request.headers['x-platform'] || request.headers['HTTP_PLATFORM']
           # validate parameters
          raise 'Missing authentication_token' if token.blank?
          @tv.validate!(token, platform)
          @current_user = @tv.user
          @current_session = @tv.session
          rescue UserSessionValidator::TokenValidatorError => e
            raise e.message
          end
      end
    end
  end
end
