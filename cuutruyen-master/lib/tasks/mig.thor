require 'thor'
require File.expand_path('config/environment.rb')

class Mig < Thor
  desc "newest_chapter", "TODO"
  def newest_chapter
    Manga.kept.find_each do |m|
      if m.chapters.kept.size > 0
        newest_chapter = m.chapters.kept.order(created_at: :desc).first
        m.update newest_chapter: newest_chapter
      end
    end
  end

  desc "primary_title", "TODO"
  def primary_title
    Manga.all.find_each do |m|
      if m.titles.size > 0
        primary_title = m.titles.where(primary: true).first
        m.update primary_title: primary_title
      end
    end
  end

  desc "trending_score", "TODO"
  def trending_score
    Manga.kept.find_each do |m|
      m.recalculate_trending_score
    end
  end
end
