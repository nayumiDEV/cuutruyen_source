class AddViewsCountToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :views_count, :integer
  end
end
