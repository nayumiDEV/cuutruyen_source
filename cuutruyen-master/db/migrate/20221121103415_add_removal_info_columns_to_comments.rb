class AddRemovalInfoColumnsToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :removed_at, :datetime, null: true
    add_reference :comments, :remover, null: true, foreign_key: { to_table: :users }
    add_column :comments, :remove_reason, :text, null: true
  end
end
