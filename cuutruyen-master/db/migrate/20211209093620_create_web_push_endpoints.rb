class CreateWebPushEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :web_push_endpoints do |t|
      t.references :user, null: false, foreign_key: true
      t.text :endpoint_url
      t.text :auth
      t.text :p256dh

      t.timestamps
    end

    add_index :web_push_endpoints, [:user_id, :endpoint_url], :unique => true
  end
end
