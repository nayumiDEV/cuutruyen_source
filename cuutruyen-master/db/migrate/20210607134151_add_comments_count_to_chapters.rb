class AddCommentsCountToChapters < ActiveRecord::Migration[6.0]
  def self.up
    add_column :chapters, :comments_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :chapters, :comments_count
  end
end
