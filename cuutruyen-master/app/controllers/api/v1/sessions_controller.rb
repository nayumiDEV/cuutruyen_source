# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  def login
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      render(json: {
        user_id: user.id,
        auth_token: user.auth_token,
      }, status: :accepted)
    else
      render(json: {
        error: 'Wrong username or password.',
      }, status: :unprocessable_entity)
    end
  end

  def logout
    current_user.regenerate_auth_token
    current_user.update_attribute(:auth_token_valid_until, 1.month.from_now)

    render(json: {
      message: 'Logged out successfully.',
    }, status: :accepted)
  end

  def geo
    current_geo =
      if Rails.env.development?
        'VN'
      elsif request.headers['HTTP_CF_IPCOUNTRY'].present?
        request.headers['HTTP_CF_IPCOUNTRY']
      else
        'VN'
      end

    render(json: {
      geo: current_geo
    })
  end
end
