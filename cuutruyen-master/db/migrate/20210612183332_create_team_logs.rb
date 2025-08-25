class CreateTeamLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :team_logs do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :views_count
      t.date :date
    end
    add_index :team_logs, [:team_id, :date], unique: true
  end
end
