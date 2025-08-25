# frozen_string_literal: true

class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.string(:number)
      t.string(:name)
      t.references(:translation, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
