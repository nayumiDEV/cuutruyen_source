class Api::V2::TeamManage::MangasController < Api::V2::TeamManage::BaseController
  def index
    authorize current_team, :simple_manage?
    if params[:q].present?
      mangas_result = Manga.includes(:translation).pagy_search(params[:q], filter: ['is_discarded = false', "team_id = #{current_team.id}"])
      @pagy, @mangas = pagy_meilisearch(mangas_result, items: per_page)
    else
      @pagy, @mangas =
        pagy(
          current_team.mangas.kept.includes(:translation, :author, :titles, :newest_chapter, :primary_title)
            .joins_newest_chapter.joins_primary_title
            .order('newest_chapter.created_at': :desc),
          items: per_page
        )
    end
  end

  def show
    authorize current_team, :simple_manage?
    @manga = current_team.mangas.kept.find(params[:id])
    @translation = @manga.translation
    raise NotFoundError, 'Truyện bạn đang truy xuất không tồn tại bản dịch nào' unless @translation.present?
    @team = @translation.team
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def create
    authorize current_team, :advanced_manage?
    @manga = Manga.new manga_params
    if manga_params[:description].blank?
      @manga.description = ""
    end

    if @manga.save
      @manga.update_column :primary_title_id, @manga.titles.where(primary: true).first&.id
      @translation = Translation.create language: 'vi', manga: @manga, team: current_team
      head :created
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @manga.errors)
    end
  end

  def update
    authorize current_team, :advanced_manage?

    @manga = current_team.mangas.kept.find(params[:id])

    if @manga.update manga_params
      @manga.update_column :primary_title_id, @manga.titles.where(primary: true).first&.id
      head :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @manga.errors)
    end
  end

  def change_chapters_order
    authorize current_team, :advanced_manage?

    @manga = current_team.mangas.kept.find(params[:id])

    @chapters_order = params[:chapters]

    ActiveRecord::Base.transaction do
      @manga.lock!
      @chapters_order.each do |chapter_order|
        chapter = Chapter.find(chapter_order['id'])
        chapter.update_column(:order, chapter_order['order'])
      end
    end

    head :accepted
  end

  def destroy
    authorize current_team, :advanced_manage?
    @manga = current_team.mangas.kept.find(params[:id])
    @translation = @manga.translation
    @manga.discard
    @translation.discard
    head :accepted
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
      titles_attributes: [:id, :name, :primary, :_destroy]
    )
  end
end
