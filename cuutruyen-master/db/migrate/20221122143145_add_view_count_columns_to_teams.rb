class AddViewCountColumnsToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :views_count_week, :integer, :default => 0, :null => false
    add_column :teams, :views_count_month, :integer, :default => 0, :null => false
  end
end
