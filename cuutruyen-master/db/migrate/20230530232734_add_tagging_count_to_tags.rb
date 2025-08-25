class AddTaggingCountToTags < ActiveRecord::Migration[6.1]
  def self.up
    add_column :tags, :tagging_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :tags, :tagging_count
  end
end
