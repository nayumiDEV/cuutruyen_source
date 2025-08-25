class CreateAbitraryPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :abitrary_photos do |t|
      t.jsonb :abitrary_photo_data

      t.timestamps
    end
  end
end
