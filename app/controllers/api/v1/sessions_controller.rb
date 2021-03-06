# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::AuthenticatedController
  skip_before_action :authorize_user!, only: %i[create], raise: false

  #POST /api/v1/sign_in
  def create
    ug = UserGenerator.new
    
    begin
      ug.validate!(sign_in_params)
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError,  UserGenerator::ConfirmationError, UserGenerator::InvalidCredentials => e
      render_exception(e, 422) && return
    end
    json_response(UserSessionSerializer.new(
      ug.user,
      { params: 
        { 
          token: ug.session.token, 
          current_user: ug.user
        }
      }
    ).serializable_hash[:data][:attributes])
  end

   #DELETE /api/v1/logout
   def logout
    begin
      current_session.destroy
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password, :platform)
  end
end