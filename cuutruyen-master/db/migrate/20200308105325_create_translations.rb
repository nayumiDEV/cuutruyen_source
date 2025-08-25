# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :translations do |t|
      t.string(:language)
      t.references(:manga, null: false, foreign_key: true)
      t.references(:team, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
