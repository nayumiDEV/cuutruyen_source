class ChangeViewsCountOnTeamLogs < ActiveRecord::Migration[6.1]
  def change
    change_column :team_logs, :views_count, :integer, :default => 0, :null => false
  end
end
