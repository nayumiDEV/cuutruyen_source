class ChangeDrmDataFieldInPagesColumns < ActiveRecord::Migration[6.0]
  def change
    change_table :pages do |t|
      t.change :drm_data, :text
    end
  end
end
