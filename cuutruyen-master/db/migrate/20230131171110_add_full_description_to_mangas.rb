class AddFullDescriptionToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :full_description, :text
  end
end
