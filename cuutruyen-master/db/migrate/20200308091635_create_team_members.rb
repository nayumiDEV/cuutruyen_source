# frozen_string_literal: true

class CreateTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_members do |t|
      t.references(:user, null: false, foreign_key: true)
      t.references(:team, null: false, foreign_key: true)
      t.integer(:role)

      t.timestamps
    end
  end
end
