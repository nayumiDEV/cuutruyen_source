class ChangeMangasColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column(:mangas, :feature_image_data, :panorama_data)
  end
end
