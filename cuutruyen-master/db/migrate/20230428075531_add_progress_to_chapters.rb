class AddProgressToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :progress, :float, default: 0.0
  end
end
