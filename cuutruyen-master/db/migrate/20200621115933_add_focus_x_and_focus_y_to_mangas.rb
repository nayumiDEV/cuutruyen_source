class AddFocusXAndFocusYToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas, :focus_x, :integer
    add_column :mangas, :focus_y, :integer
  end
end
