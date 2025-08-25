# frozen_string_literal: true

class AddDrmDataToPages < ActiveRecord::Migration[6.0]
  def change
    add_column(:pages, :drm_data, :string)
  end
end
