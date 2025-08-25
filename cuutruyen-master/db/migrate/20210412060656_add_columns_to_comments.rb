class AddColumnsToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :chapter, null: true, foreign_key: true
    add_reference :comments, :translation, null: true, foreign_key: true
  end
end
