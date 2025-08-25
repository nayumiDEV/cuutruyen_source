class AddDiscardedAtToTranslations < ActiveRecord::Migration[6.0]
  def change
    add_column :translations, :discarded_at, :datetime
    add_index :translations, :discarded_at
  end
end
