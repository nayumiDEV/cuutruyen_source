class AddColumnToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :is_ads, :boolean, default: true
  end
end
