class ChangeColumnPagesCountFromChapters < ActiveRecord::Migration[6.0]
  def change
    Chapter.update_all pages_count: 0

    change_column_null :chapters, :pages_count, false
    change_column_default :chapters, :pages_count, 0
  end
end
