class AddDiscardedAtToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column :chapters, :discarded_at, :datetime
    add_index :chapters, :discarded_at
  end
end
