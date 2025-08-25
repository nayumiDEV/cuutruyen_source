class ChangeViewsCountOnMangas < ActiveRecord::Migration[6.1]
  def change
    change_column :mangas, :views_count, :integer, :default => 0, :null => false
  end
end
