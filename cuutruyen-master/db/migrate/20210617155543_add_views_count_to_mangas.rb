class AddViewsCountToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :views_count, :integer
  end
end
