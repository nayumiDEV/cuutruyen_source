class AddAvatarDataToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :avatar_data, :jsonb
  end
end
