class CreateMangaLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :manga_logs do |t|
      t.references :manga, null: false, foreign_key: true
      t.integer :views_count
      t.date :date
    end
    add_index :manga_logs, [:manga_id, :date], unique: true
  end
end
