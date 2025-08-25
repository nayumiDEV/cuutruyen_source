class AddCategoryToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :category, :integer, default: 0
  end
end
