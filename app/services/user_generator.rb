# frozen_string_literal: true
class UserGenerator
  class ParameterNotFound < StandardError; end
  class DuplicateError < StandardError; end
  class InvalidCredentials < StandardError; end
  class ConfirmationError < StandardError; end

  attr_reader :user, :platform, :session

  def generate!(params)
    # validate parameters
    raise ParameterNotFound, 'Missing email' if params[:email].blank?

    user = User.find_by(email: params[:email].downcase)
    raise DuplicateError, 'This email has exists.' if user.present?

    if user.blank?
      user = User.new(params)
    end
    user.role = "admin"
    user.save!
    user.confirm
    @user = user
    
    true
  end

  def validate!(params)
    
    # validate parameters
    raise ParameterNotFound, 'Missing email' if params[:email].blank?
    raise ParameterNotFound, 'Missing password' if params[:password].blank?
    
    # validate
    user = User.find_by(email: params[:email].try(:downcase))
    raise ParameterNotFound, 'Email does not Exist.' if !user.present?
    raise InvalidCredentials, 'Invalid Password.' unless user.valid_password?(params[:password])
    raise ConfirmationError, 'Your email address is not confirmed yet, Please confirm it.' unless user.confirmed?

    session = UserSession.find_or_initialize_by(user: user, platform: params[:platform])
      
    # generate (unique) token & save
    session.token = generate_token

    user.save!
    session.save!

    # assign for instance
    @session = session
    @user = user

    true
  end

  private
  
  def generate_token
    token_generator = SecureRandom.urlsafe_base64(128).tr('lIO0-', 'sxyzz')
    loop do
      token = token_generator
      break token unless UserSession.exists?(token: token)
    end
  end
end
  