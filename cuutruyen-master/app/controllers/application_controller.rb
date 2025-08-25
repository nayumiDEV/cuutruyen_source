# frozen_string_literal: true

class ApplicationController < ActionController::API
  class AuthenticationFailed < StandardError; end

  include Pundit

  before_action :current_user

  def current_user
    user_id = request.headers["HTTP_M4U_UID"]
    token = request.headers["HTTP_M4U_TOKEN"]
    if user_id && token
      user = User.find(user_id)
      if user.auth_token == token
        @current_user ||= user
      else
        raise AuthenticationFailed, 'Wrong authentication token.'
      end
    end

  rescue ActiveRecord::RecordNotFound
    raise AuthenticationFailed, 'Authenticating user not found.'
  end

  register_exception AuthenticationFailed,
    status: 401,
    title: 'Authentication failed',
    detail: ->(e) { e.message }

  register_exception Pundit::NotAuthorizedError,
    status: 403,
    title: 'You cannot perform this action.',
    detail: ->(e) { e.message.capitalize }
end
