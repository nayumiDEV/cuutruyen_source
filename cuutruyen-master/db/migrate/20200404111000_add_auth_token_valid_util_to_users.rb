# frozen_string_literal: true
class AddAuthTokenValidUtilToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :auth_token_valid_until, :datetime)
  end
end
