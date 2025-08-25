# frozen_string_literal: true

class AddOrderToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column(:chapters, :order, :integer)
  end
end
