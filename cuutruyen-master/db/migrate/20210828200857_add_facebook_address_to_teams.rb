class AddFacebookAddressToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :facebook_address, :string
  end
end
