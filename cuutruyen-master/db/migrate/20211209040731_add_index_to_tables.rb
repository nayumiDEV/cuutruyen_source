class AddIndexToTables < ActiveRecord::Migration[6.1]
  def change
    add_index :chapters, :order
    add_index :pages, :order
  end
end
