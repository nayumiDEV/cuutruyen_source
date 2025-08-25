class TrendingCalculator
  CUUTRUYEN_EPOCH = 1598710020

  def initialize
  end

  def calculate manga
    return unless manga.newest_chapter
    views_count = if manga.newest_chapter.views_count >= 1
                    manga.newest_chapter.views_count
                  else
                    1
                  end

    comments_count = if manga.newest_chapter.comments_count >= 1
                       manga.newest_chapter.comments_count
                     else
                       1
                     end

    time_diff = manga.newest_chapter.created_at.to_i - CUUTRUYEN_EPOCH

    score = Math.log(views_count, 15) + Math.log(comments_count, 5) + (time_diff.to_f / 45000)
  end
end
