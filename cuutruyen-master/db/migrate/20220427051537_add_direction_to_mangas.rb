class AddDirectionToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :direction, :integer, default: 0
  end
end
