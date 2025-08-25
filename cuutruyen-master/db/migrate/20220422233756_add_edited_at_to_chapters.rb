class AddEditedAtToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :edited_at, :datetime
  end
end
