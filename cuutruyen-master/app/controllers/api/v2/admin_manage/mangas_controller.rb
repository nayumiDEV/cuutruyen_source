class Api::V2::AdminManage::MangasController < Api::V2::AdminManage::BaseController
  def index
    if params[:q].present?
      mangas_result = Manga.includes(:team, :translation, :author, :titles, :newest_chapter, :primary_title).pagy_search(params[:q], filter: ['is_discarded = false'])
      @pagy, @mangas = pagy_meilisearch(mangas_result, items: per_page)
    else
      @pagy, @mangas = pagy(
        Manga.kept.includes(:team, :translation, :author, :titles, :newest_chapter, :primary_title)
          .joins_newest_chapter.joins_primary_title
          .order('newest_chapter.created_at': :desc),
        items: per_page
      )
    end
  end

  def show
    @manga = Manga.kept.find(params[:id])
    @translation = @manga.translation
    raise NotFoundError, 'Truyện bạn đang truy xuất không tồn tại bản dịch nào' unless @translation.present?
    @team = @translation.team
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def update
    @manga = Manga.find(params[:id])

    if @manga.update manga_params
      @manga.translation.update_column :team_id, params[:manga][:team_id]
      @manga.update_column :primary_title_id, @manga.titles.where(primary: true).first&.id
      head :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @manga.errors)
    end
  end

  private

  def manga_params
    params.require(:manga).permit(
      :name,
      :description,
      :full_description,
      :cover,
      :panorama,
      :marginless,
      :official_url,
      :direction,
      tags_list: [],
      author_attributes: [:name],
      titles_attributes: [:id, :name, :primary, :_destroy],
    )
  end
end
