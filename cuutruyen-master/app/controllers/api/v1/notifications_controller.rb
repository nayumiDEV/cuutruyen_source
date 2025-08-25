# frozen_string_literal: true
class Api::V1::NotificationsController < ApplicationController
  def index
    notifications = NotificationResource.all(params)
    render(jsonapi: notifications)
  end

  def show
    notification = NotificationResource.find(params)
    render(jsonapi: notification)
  end

  def create
    notification = NotificationResource.build(params)

    if notification.save
      render(jsonapi: notification, status: 201)
    else
      render(jsonapi_errors: notification)
    end
  end

  def update
    notification = NotificationResource.find(params)

    if notification.update_attributes
      render(jsonapi: notification)
    else
      render(jsonapi_errors: notification)
    end
  end

  def destroy
    notification = NotificationResource.find(params)

    if notification.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: notification)
    end
  end
end
