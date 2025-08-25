# frozen_string_literal: true
class Api::V1::NotificationReadAllsController < ApplicationController
  def create
    notification_read_all = NotificationReadAllResource.build(params)

    if notification_read_all.save
      render(jsonapi: notification_read_all, status: 201)
    else
      render(jsonapi_errors: notification_read_all)
    end
  end
end
