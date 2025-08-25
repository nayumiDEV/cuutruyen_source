class ChangeDataTypeForTrendingScore < ActiveRecord::Migration[6.1]
  def change
    change_column :mangas, :trending_score, :decimal, precision: 15, scale: 10
    add_index :mangas, :trending_score
  end
end
