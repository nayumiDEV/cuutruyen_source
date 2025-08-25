# frozen_string_literal: true
class CategoryResource < ApplicationResource
  many_to_many :mangas

  attribute :name, :string
  attribute :description, :string
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
