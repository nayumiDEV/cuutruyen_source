class CommentReply < ApplicationRecord
  belongs_to :replied, class_name: 'Comment', foreign_key: 'reply_id'
  belongs_to :reply, class_name: 'Comment', foreign_key: 'replied_id'
end
