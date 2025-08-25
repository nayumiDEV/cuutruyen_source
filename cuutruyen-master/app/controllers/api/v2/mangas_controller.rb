class Api::V2::MangasController < Api::V2::BaseController
  def show
    @manga = Manga.kept.find(params[:id])
    @translation = @manga.translations.first
    raise NotFoundError, 'Truyện bạn đang truy xuất không tồn tại bản dịch nào' unless @translation.present?
    @team = @translation.team
    @is_following =
      if current_user.present?
        current_user.manga_follows.where(id: @manga.id).first.present?
      else
        false
      end
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def search
    @keyword = params[:q]
    mangas_result = Manga.pagy_search(params[:q], filter: ['is_discarded = false'])
    @pagy, @mangas = pagy_meilisearch(mangas_result, items: per_page)
  end

  def quick_search
    @keyword = params[:q]
    @mangas = Manga.search(@keyword, limit: 5, filter: ['is_discarded = false'])
  end

  def spotlight
    @mangas = Manga.kept.includes(:author, :newest_chapter, :primary_title).has_chapter(true).order(trending_score: :desc).limit(6)
  end

  def recently_updated
    if params[:team_id]
      team = Team.find_by(id: params[:team_id])
    end

    mangas = Manga.kept
                  .includes(:author, :newest_chapter, :primary_title)
                  .joins_newest_chapter
                  .where(status: :processed)
                  .has_chapter(true)
                  .order('newest_chapter.created_at': :desc)

    if team
      mangas = mangas.joins(:translations).where(translations: { team_id: team.id })
    end

    @pagy, @mangas = pagy(mangas, items: per_page)
  end

  def top
    duration = params[:duration] || 'week'
    team_id = params[:team_id]
    page = params[:page] || 1

    # Cache key includes duration, team_id, page, per_page, and current date for daily refresh
    cache_key = "mangas_top_#{duration}_team_#{team_id}_page_#{page}_per_page_#{per_page}_#{Date.current.strftime('%Y%m%d')}"

    cached_result = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      team = Team.find_by(id: team_id) if team_id

      mangas = Manga.kept
                    .includes(:author, :newest_chapter, :primary_title)
                    .where(status: :processed)
                    .has_chapter(true)

      case duration
      when 'week'
        mangas = mangas.order('views_count_week': :desc)
      when 'month'
        mangas = mangas.order('views_count_month': :desc)
      when 'all'
        mangas = mangas.order('views_count': :desc)
      else
        mangas = mangas.order('views_count_week': :desc)
      end

      if team
        mangas = mangas.joins(:translations).where(translations: { team_id: team.id })
      end

      pagy(mangas, items: per_page, page: page)
    end

    @pagy, @mangas = cached_result
  end

  def suggested
    @top_mangas = Manga.kept.includes(:author, :newest_chapter, :primary_title).where(status: :processed).has_chapter(true).order('views_count_week': :desc).limit(40)
    if params[:team_id]
      @top_mangas = @top_mangas.joins(:team).where(team: { id: params[:team_id] }).limit(20)
    end
    @mangas = @top_mangas.sample(5)
  end

  def suggested_a
    @top_mangas = Manga.kept.includes(:author, :newest_chapter, :primary_title).where(status: :processed).has_chapter(true).order('views_count_week': :desc).limit(40)
    @top_team_mangas = @top_mangas.joins(:team).where(team: { id: params[:team_id] }).limit(20)

    @rand_top_mangas = @top_mangas.sample(5)
    @rand_top_team_mangas = @top_team_mangas.sample(5)
  end

  def following
    raise UnauthorizedError, 'Bạn cần đăng nhập để sử dụng tính năng này' unless current_user.present?
    @pagy, @mangas = pagy(current_user.manga_follows.kept.includes(:author, :newest_chapter, :primary_title).joins_newest_chapter.where(status: :processed).has_chapter(true).order('newest_chapter.created_at': :desc), items: per_page)
  end

  def follow
    raise UnauthorizedError, 'Bạn cần đăng nhập để sử dụng tính năng này' unless current_user.present?
    manga = Manga.find(params[:id])
    current_user.user_follow_mangas.create(manga: manga)

    head :accepted
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def unfollow
    raise UnauthorizedError, 'Bạn cần đăng nhập để sử dụng tính năng này' unless current_user.present?
    manga = Manga.find(params[:id])
    current_user.user_follow_mangas.where(manga: manga).destroy_all

    head :accepted
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end
end
