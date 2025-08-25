# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string(:username)
      t.string(:email)
      t.string(:password_digest)
      t.integer(:level)
      t.string(:auth_token)

      t.timestamps
    end
    add_index(:users, :username, unique: true)
    add_index(:users, :email, unique: true)
    add_index(:users, :auth_token, unique: true)
  end
end
