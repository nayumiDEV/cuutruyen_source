class AddMarginlessColumnToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas, :marginless, :boolean, default: false
  end
end
