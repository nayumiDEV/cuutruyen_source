class AddIsRegionLimitedToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :is_region_limited, :boolean, default: false
  end
end
