# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string(:name)
      t.text(:description)

      t.timestamps
    end
  end
end
