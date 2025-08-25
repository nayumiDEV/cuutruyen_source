class AddDiscardedAtToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas, :discarded_at, :datetime
    add_index :mangas, :discarded_at
  end
end
