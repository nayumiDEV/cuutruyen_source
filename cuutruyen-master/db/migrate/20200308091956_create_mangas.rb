# frozen_string_literal: true

class CreateMangas < ActiveRecord::Migration[6.0]
  def change
    create_table :mangas do |t|
      t.string(:name)
      t.text(:description)
      t.references(:author, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
