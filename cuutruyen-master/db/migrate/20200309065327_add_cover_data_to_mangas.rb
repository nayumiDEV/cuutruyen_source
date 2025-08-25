# frozen_string_literal: true

class AddCoverDataToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column(:mangas, :cover_data, :text)
  end
end
