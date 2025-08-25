class CreateMangasTags < ActiveRecord::Migration[6.1]
  def change
    create_table :mangas_tags do |t|
      t.references :manga, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
