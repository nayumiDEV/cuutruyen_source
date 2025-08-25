# frozen_string_literal: true

class AddPagesCountToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column(:chapters, :pages_count, :integer)

    Chapter.reset_column_information
    Chapter.all.each do |c|
      Chapter.update_counters(c.id, pages_count: c.pages.length)
    end
  end

  def down
    remove_column(:chapters, :pages_count)
  end
end
