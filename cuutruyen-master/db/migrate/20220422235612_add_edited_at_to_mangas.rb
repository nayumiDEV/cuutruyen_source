class AddEditedAtToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :edited_at, :datetime
  end
end
