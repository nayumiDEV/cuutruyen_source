class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :unique_code
      t.text :message
      t.string :name
      t.string :email
      t.string :sepay_id
      t.string :sepay_reference_code
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
