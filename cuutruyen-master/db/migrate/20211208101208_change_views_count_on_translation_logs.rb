class ChangeViewsCountOnTranslationLogs < ActiveRecord::Migration[6.1]
  def change
    change_column :translation_logs, :views_count, :integer, :default => 0, :null => false
  end
end
