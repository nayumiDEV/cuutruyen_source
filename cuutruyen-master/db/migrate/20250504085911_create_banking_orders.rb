class CreateBankingOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :banking_orders do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :unique_code
      t.text :message
      t.string :name
      t.string :email
      t.datetime :valid_until
      t.datetime :paid_at
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
