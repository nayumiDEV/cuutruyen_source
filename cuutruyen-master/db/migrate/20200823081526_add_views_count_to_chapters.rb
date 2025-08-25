# frozen_string_literal: true
class AddViewsCountToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column(:chapters, :views_count, :integer, default: 0)
  end
end
