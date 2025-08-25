# frozen_string_literal: true
class UserResource < ApplicationResource
  many_to_many :teams
  many_to_many :manga_follows, resource: MangaResource
  polymorphic_has_many :notifications, as: :recipient

  attribute :username, :string, writable: false
  attribute :email, :string, readable: :sensitive_readable?, writable: false
  attribute :level, :string, writable: false
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  def sensitive_readable?(model)
    UserPolicy.new(current_user, model).show_sensitive?
  end

  def base_scope
    Pundit.policy_scope(current_user, User)
  end
end
