class Api::V2::TeamManage::ChaptersController < Api::V2::TeamManage::BaseController
  def index
    authorize current_team, :simple_manage?
    @manga = current_team.mangas.kept.find params[:manga_id]
    @translation = @manga.translation
    @chapters = @translation.chapters.kept.order(order: :desc)
    raise NotFoundError, 'Truyện bạn đang truy xuất không tồn tại bản dịch nào' unless @translation.present?
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def sort
    authorize current_team, :advanced_manage?
    @manga = current_team.mangas.kept.find params[:manga_id]
    @translation = @manga.translation

    raise ForbiddenError, 'Truyện bạn đang cố gắng sắp xếp chương không tồn tại' unless @translation.present? && @translation.team == current_team

    @chapters = @translation.chapters.kept.order(order: :desc)

    ActiveRecord::Base.transaction do
      # Convert chapters to a hash for O(1) lookup
      chapter_map = @chapters.index_by(&:id)

      params[:chapters].each do |chapter_id, order|
        # Ensure we only update chapters that belong to our collection
        if chapter = chapter_map[chapter_id.to_i]
          chapter.update_column(:order, order)
        end
      end
    end

    head :accepted
  end

  def show
    authorize current_team, :simple_manage?
    @chapter = current_team.chapters.kept.find(params[:id])
  end

  def create
    authorize current_team, :advanced_manage?
    @manga = current_team.mangas.kept.find params[:manga_id]
    @translation = @manga.translation

    raise ForbiddenError, 'Truyện bạn đang cố gắng tạo chương không tồn tại' unless @translation.present? && @translation.team == current_team

    @chapter = current_team.chapters.new(chapter_params)
    @chapter.translation = @translation
    if @chapter.save
      head :created
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @chapter.errors)
    end
  end

  def update
    authorize current_team, :advanced_manage?
    @chapter = current_team.chapters.kept.find(params[:id])
    if @chapter.update(chapter_params)
      head :accepted
    else
      raise UnprocessableEntityError.new('Vui lòng kiểm tra lại nội dung bạn nhập', @chapter.errors)
    end
  end

  def destroy
    authorize current_team, :advanced_manage?
    @chapter = current_team.chapters.kept.find(params[:id])
    @chapter.discard
    head :accepted
  end

  private

  def chapter_params
    params.require(:chapter).permit(:number, :name, :order, :visibility, pages_attributes: [:id, :image, :order])
  end
end
