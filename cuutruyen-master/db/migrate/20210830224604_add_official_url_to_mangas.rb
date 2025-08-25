class AddOfficialUrlToMangas < ActiveRecord::Migration[6.1]
  def change
    add_column :mangas, :official_url, :string
  end
end
