class MakeCommentsPolymorphic < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :commentable_type, :string, null: false, default: 'Chapter'
    add_column :comments, :commentable_id, :bigint, null: false, default: 0
    add_index :comments, [:commentable_type, :commentable_id]
    
    # Backfill existing data
    Comment.reset_column_information
    Comment.update_all("commentable_type = 'Chapter', commentable_id = chapter_id")
  end
  
  def down
    remove_index :comments, [:commentable_type, :commentable_id]
    remove_column :comments, :commentable_id
    remove_column :comments, :commentable_type
  end
end
