class AddStatusToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas, :status, :integer
  end
end
