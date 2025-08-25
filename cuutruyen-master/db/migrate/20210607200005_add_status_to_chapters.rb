class AddStatusToChapters < ActiveRecord::Migration[6.0]
  def change
    add_column :chapters, :status, :integer, null: false, default: 0
  end
end
