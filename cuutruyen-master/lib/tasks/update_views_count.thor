require 'thor'
require File.expand_path('config/environment.rb')

class UpdateViewsCount < Thor
  desc "translations", "TODO"
  def translations
    Translation.all.find_each do |translation|
      sum_views_count = translation.chapters.kept.sum(:views_count)
      translation.update_columns views_count: sum_views_count
    end
  end

  desc "teams", "TODO"
  def teams
    Team.all.find_each do |team|
      sum_views_count = team.chapters.kept.sum(:views_count)
      team.update_columns views_count: sum_views_count
    end
  end

  desc "mangas", "TODO"
  def mangas
    Manga.all.find_each do |manga|
      sum_views_count = manga.translations.kept.sum(:views_count)
      manga.update_columns views_count: sum_views_count
    end
  end
end
