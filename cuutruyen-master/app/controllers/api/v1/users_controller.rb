# frozen_string_literal: true
class Api::V1::UsersController < ApplicationController
  def index
    users = UserResource.all(params)
    render(jsonapi: users)
  end

  def show
    user = UserResource.find(params)
    render(jsonapi: user)
  end

  def create
    user = RegistrationResource.build(params)

    if user.save
      render(jsonapi: user, status: :created)
    else
      render(jsonapi_errors: user)
    end
  end
end
