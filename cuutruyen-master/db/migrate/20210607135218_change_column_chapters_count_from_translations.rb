class ChangeColumnChaptersCountFromTranslations < ActiveRecord::Migration[6.0]
  def change
    Translation.update_all chapters_count: 0

    change_column_null :translations, :chapters_count, false
    change_column_default :translations, :chapters_count, 0
  end
end
