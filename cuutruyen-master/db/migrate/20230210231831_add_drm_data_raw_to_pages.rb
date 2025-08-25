class AddDrmDataRawToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :drm_data_raw, :text
  end
end
