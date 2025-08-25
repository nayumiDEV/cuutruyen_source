class WebPushEndpoint < ApplicationRecord
  belongs_to :user

  validates :endpoint_url, uniqueness: { scope: :user }
end
