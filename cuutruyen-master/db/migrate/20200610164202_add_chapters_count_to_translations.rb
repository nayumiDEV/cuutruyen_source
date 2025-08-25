# frozen_string_literal: true
class AddChaptersCountToTranslations < ActiveRecord::Migration[6.0]
  def up
    add_column(:translations, :chapters_count, :integer)

    Translation.reset_column_information
    Translation.all.each do |t|
      Translation.update_counters(t.id, chapters_count: t.chapters.length)
    end
  end

  def down
    remove_column(:translations, :chapters_count)
  end
end
