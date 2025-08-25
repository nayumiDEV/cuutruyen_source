# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.references(:chapter, null: false, foreign_key: true)
      t.integer(:order)

      t.timestamps
    end
  end
end
