class AddViewCountColumnsToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :views_count_week, :integer
    add_column :mangas, :views_count_month, :integer
  end
end
