# frozen_string_literal: true
class RegistrationResource < ApplicationResource
  primary_endpoint '/users', [:create]

  self.model = User
  self.type = :users

  attribute :username, :string
  attribute :email, :string
  attribute :password, :string, readable: false
  attribute :password_confirmation, :string, readable: false
  attribute :auth_token, :string, writable: false
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  before_commit do |model|
    model.update_attribute(:auth_token_valid_until, 1.month.from_now)
  end
end
