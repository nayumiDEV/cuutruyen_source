class CreateUserBans < ActiveRecord::Migration[6.1]
  def change
    create_table :user_bans do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :ban_type
      t.string :reason
      t.datetime :banned_until

      t.timestamps
    end
  end
end
