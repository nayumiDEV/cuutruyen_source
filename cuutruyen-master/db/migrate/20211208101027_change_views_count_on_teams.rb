class ChangeViewsCountOnTeams < ActiveRecord::Migration[6.1]
  def change
    change_column :teams, :views_count, :integer, :default => 0, :null => false
  end
end
