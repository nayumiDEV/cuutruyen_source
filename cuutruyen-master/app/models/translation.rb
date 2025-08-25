# frozen_string_literal: true

class Translation < ApplicationRecord
  include Discard::Model

  belongs_to :manga, touch: true
  belongs_to :team
  has_many :chapters, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :language, presence: true

  counter_culture :team
end
