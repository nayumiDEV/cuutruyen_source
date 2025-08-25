class MangaTag < ApplicationRecord
  self.table_name = "mangas_tags"

  belongs_to :manga
  belongs_to :tag

  counter_culture :tag, column_name: "tagging_count"
end
