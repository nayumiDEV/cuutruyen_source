class ChangeViewsCountWeekAndMonthOnMangas < ActiveRecord::Migration[6.1]
  def change
    change_column :mangas, :views_count_week, :integer, :default => 0, :null => false
    change_column :mangas, :views_count_month, :integer, :default => 0, :null => false
  end
end
