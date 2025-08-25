# frozen_string_literal: true

class CategoryManga < ApplicationRecord
  belongs_to :category
  belongs_to :manga
end
