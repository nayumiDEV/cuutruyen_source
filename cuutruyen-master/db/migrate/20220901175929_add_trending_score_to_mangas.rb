class AddTrendingScoreToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :trending_score, :bigint, default: 0
  end
end
