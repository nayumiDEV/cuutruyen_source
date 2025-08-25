# frozen_string_literal: true
class TitleResource < ApplicationResource
  belongs_to :manga

  attribute :name, :string
  attribute :primary, :boolean
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
  attribute :manga_id, :integer, only: [:filterable]
end
