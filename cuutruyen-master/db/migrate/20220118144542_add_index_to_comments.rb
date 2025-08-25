class AddIndexToComments < ActiveRecord::Migration[6.1]
  def change
    add_index :comments, :created_at
  end
end
