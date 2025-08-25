# frozen_string_literal: true
class TeamResource < ApplicationResource
  many_to_many :users
  has_many :translations
  many_to_many :mangas

  attribute :name, :string
  attribute :description, :string
  attribute :facebook_address, :string
  attribute :is_ads, :boolean
  attribute :views_count, :integer
  attribute :translations_count, :integer
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false

  def base_scope
    Pundit.policy_scope(current_user, Team)
  end
end
