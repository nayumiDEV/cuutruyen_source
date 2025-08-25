# frozen_string_literal: true

class AddImageDataToPages < ActiveRecord::Migration[6.0]
  def change
    add_column(:pages, :image_data, :text)
  end
end
