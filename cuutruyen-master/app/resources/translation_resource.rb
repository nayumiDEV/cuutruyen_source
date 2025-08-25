# frozen_string_literal: true
class TranslationResource < ApplicationResource
  belongs_to :team
  belongs_to :manga
  has_many :chapters
  has_many :comments

  attribute :language, :string
  attribute :chapters_count, :integer, writable: false
  attribute :views_count, :integer, writable: false
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
  attribute :manga_id, :integer, only: [:filterable]
  attribute :team_id, :integer, only: [:filterable]

  def delete(model)
    model.discard
    model
  end

  def base_scope
    Pundit.policy_scope(current_user, Translation.kept)
  end
end
