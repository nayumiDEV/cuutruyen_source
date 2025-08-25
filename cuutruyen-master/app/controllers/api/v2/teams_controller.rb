class Api::V2::TeamsController < Api::V2::BaseController
  def top
    duration = params[:duration] || 'week'
    page = params[:page] || 1
    
    # Cache key includes duration, page, per_page, and current date for daily refresh
    cache_key = "teams_top_#{duration}_page_#{page}_per_page_#{per_page}_#{Date.current.strftime('%Y%m%d')}"
    
    cached_result = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      case duration
      when 'week'
        pagy(Team.order('views_count_week': :desc), items: per_page, page: page)
      when 'month'
        pagy(Team.order('views_count_month': :desc), items: per_page, page: page)
      when 'all'
        pagy(Team.order('views_count': :desc), items: per_page, page: page)
      else
        pagy(Team.order('views_count_week': :desc), items: per_page, page: page)
      end
    end
    
    @pagy, @teams = cached_result
  end

  def show
    @team = Team.find_by(id: params[:id])
    raise NotFoundError, 'Nhóm bạn đang cố gắng truy cập không tồn tại' unless @team.present?
  end

  def get_team_by_slug
    @team = Team.find_by(slug: params[:slug])
    raise NotFoundError, 'Nhóm bạn đang cố gắng truy cập không tồn tại' unless @team.present?
    render 'show'
  end
end
