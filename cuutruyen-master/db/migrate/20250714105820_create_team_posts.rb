class CreateTeamPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :team_posts do |t|
      t.references :team, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
