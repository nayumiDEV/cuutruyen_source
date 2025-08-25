class Tag < ApplicationRecord
  include MeiliSearch::Rails

  has_many :manga_tags, dependent: :destroy
  has_many :mangas, through: :manga_tags

  enum category: { normal: 0, common: 1, warning: 2 }

  meilisearch do
    attribute :name

    ranking_rules [
      "words",
      "exactness",
      "proximity",
      "attribute",
      "sort",
      "typo"
    ]
  end
end
