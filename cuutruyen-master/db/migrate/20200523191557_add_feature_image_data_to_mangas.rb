class AddFeatureImageDataToMangas < ActiveRecord::Migration[6.0]
  def change
    add_column :mangas, :feature_image_data, :text
  end
end
