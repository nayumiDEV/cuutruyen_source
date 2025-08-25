class AddNewestChapterToMangas < ActiveRecord::Migration[6.1]
  def change
    add_reference :mangas, :newest_chapter, null: true, foreign_key: { to_table: 'chapters' }
  end
end
