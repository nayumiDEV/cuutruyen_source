class CreateTitles < ActiveRecord::Migration[6.0]
  def change
    create_table :titles do |t|
      t.string :name, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8'
      t.boolean :primary
      t.references :manga, null: false, foreign_key: true

      t.timestamps
    end
  end
end
