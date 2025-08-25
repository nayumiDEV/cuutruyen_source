class AddIsShadowRemovedToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :is_shadow_removed, :boolean, null: false, default: false
  end
end
