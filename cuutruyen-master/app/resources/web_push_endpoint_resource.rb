# frozen_string_literal: true

class WebPushEndpointResource < ApplicationResource
  belongs_to :user

  attribute :user_id, :integer
  attribute :endpoint_url, :string
  attribute :auth, :string
  attribute :p256dh, :string

  paginate do |scope|
      scope
  end

  def base_scope
    Pundit.policy_scope(current_user, WebPushEndpoint)
  end
end
