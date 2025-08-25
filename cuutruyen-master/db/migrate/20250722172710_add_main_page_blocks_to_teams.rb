class AddMainPageBlocksToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :main_page_blocks, :json
  end
end
