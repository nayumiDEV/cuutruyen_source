class CreateTranslationLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :translation_logs do |t|
      t.references :translation, null: false, foreign_key: true
      t.integer :views_count
      t.date :date
    end
    add_index :translation_logs, [:translation_id, :date], unique: true
  end
end
