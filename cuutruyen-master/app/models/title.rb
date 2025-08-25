class Title < ApplicationRecord
  belongs_to :manga, touch: true

  validates :name, presence: true, length: { in: 1..255 }

  before_destroy do
    if self.primary?
      manga.update_column :newest_chapter_id, nil
    end
  end
end
