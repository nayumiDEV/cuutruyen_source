# frozen_string_literal: true

class Author < ApplicationRecord
  include MeiliSearch::Rails

  has_many :mangas

  validates :name, presence: true, length: { in: 1..90 }
  validates :description, presence: true, :allow_blank => true, length: { in: 1..1000 }

  after_save { mangas.each(&:touch) }
end
