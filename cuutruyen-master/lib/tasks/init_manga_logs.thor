require 'thor'
require File.expand_path('config/environment.rb')

class InitMangaLogs < Thor
  desc "start", "TODO"
  def start
    TranslationLog.find_each do |translation_log|
      manga = translation_log.translation.manga

      MangaLog.upsert(
        {
          manga_id: manga.id,
          views_count: translation_log.views_count,
          date: translation_log.date
        }
      )
    end
  end
end
