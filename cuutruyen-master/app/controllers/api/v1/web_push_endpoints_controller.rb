# frozen_string_literal: true
class Api::V1::WebPushEndpointsController < ApplicationController
  def index
    web_push_endpoints = WebPushEndpointResource.all(params)
    render(jsonapi: web_push_endpoints)
  end

  def show
    web_push_endpoint = WebPushEndpointResource.find(params)
    render(jsonapi: web_push_endpoint)
  end

  def create
    web_push_endpoint = WebPushEndpointResource.build(params)

    if web_push_endpoint.save
      render(jsonapi: web_push_endpoint, status: 201)
    else
      render(jsonapi_errors: web_push_endpoint)
    end
  end

  def update
    web_push_endpoint = WebPushEndpointResource.find(params)

    if web_push_endpoint.update_attributes
      render(jsonapi: web_push_endpoint)
    else
      render(jsonapi_errors: web_push_endpoint)
    end
  end

  def destroy
    web_push_endpoint = WebPushEndpointResource.find(params)

    if web_push_endpoint.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: web_push_endpoint)
    end
  end

  def trigger_demo
    WebPushDemoNotification.with(endpoint_url: params[:endpoint_url], auth: params[:auth], p256dh: params[:p256dh]).deliver(current_user)
  end
end
