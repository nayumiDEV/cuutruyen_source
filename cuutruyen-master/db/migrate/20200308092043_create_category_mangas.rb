# frozen_string_literal: true

class CreateCategoryMangas < ActiveRecord::Migration[6.0]
  def change
    create_table :category_mangas do |t|
      t.references(:category, null: false, foreign_key: true)
      t.references(:manga, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
