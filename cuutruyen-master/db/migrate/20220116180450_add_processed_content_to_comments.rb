class AddProcessedContentToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :processed_content, :text
  end
end
