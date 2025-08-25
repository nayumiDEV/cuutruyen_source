class AddStatusToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :status, :integer, null: false, default: 0
  end
end
