class AddPrimaryTitleToMangas < ActiveRecord::Migration[6.1]
  def change
    add_reference :mangas, :primary_title, null: true, foreign_key: { to_table: 'titles' }
  end
end
