class AddTranslationsCountToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :translations_count, :integer, null: false, default: 0
  end
end
