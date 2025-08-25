class ChangeViewsCountOnChapters < ActiveRecord::Migration[6.1]
  def change
    change_column :chapters, :views_count, :integer, :default => 0, :null => false
  end
end
