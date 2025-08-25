# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :category_mangas
  has_many :mangas, through: :category_mangas

  validates :name, presence: true, length: { in: 1..90 }
  validates :description, presence: true, length: { in: 1..1000 }
end
