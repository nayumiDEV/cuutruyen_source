class Api::V2::SpecialPagesController < Api::V2::BaseController
  def home_a
    @spotlight_mangas = Manga.kept.includes(:author, :newest_chapter, :primary_title).has_chapter(true).order(trending_score: :desc).limit(6)
    @new_chapter_mangas = Manga.kept.includes(:author, :newest_chapter, :primary_title).joins_newest_chapter.where(status: :processed).has_chapter(true).order('newest_chapter.created_at': :desc).limit(25)
  end
end
