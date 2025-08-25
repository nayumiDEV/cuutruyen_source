class CreateUsersFollowMangas < ActiveRecord::Migration[6.1]
  def change
    create_table :users_follow_mangas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :manga, null: false, foreign_key: true

      t.timestamps
    end
  end
end
