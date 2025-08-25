class AddViewsCountToTranslations < ActiveRecord::Migration[6.1]
  def change
    add_column :translations, :views_count, :integer
  end
end
