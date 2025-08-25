class CreateCommentReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_replies do |t|
      t.references :replied, null: false, foreign_key: { to_table: :comments }
      t.references :reply, null: false, foreign_key: { to_table: :comments }
    end

    add_index :comment_replies, [:replied_id, :reply_id], unique: true
  end
end
