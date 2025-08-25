class Api::V2::ChaptersController < Api::V2::BaseController
  def index
    @manga = Manga.kept.find params[:manga_id]
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại' if @manga.discarded?

    @translation = @manga.translation
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại bản dịch nào' unless @translation.present?

    @chapters = @translation.chapters.kept.order(order: :desc)
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Truyện bạn đang cố gắng truy cập không tồn tại'
  end

  def show
    @chapter = Chapter.kept.with_cursor.find params[:id]
    @manga = @chapter.translation.manga
    raise NotFoundError, 'Chương bạn đang cố gắng truy cập không tồn tại' if @manga.discarded?

    @team = @chapter.translation.team
    @pages = @chapter.pages.order(:order)
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, 'Chương bạn đang cố gắng truy cập không tồn tại'
  end

  def increment
    # chapter = Chapter.find(params[:id])

    # views_counter = ViewsCounter.new
    # views_counter.increment chapter

    render(json: { status: 'success' })
  end

  def commit_views
    # Process batch updates for chapter views
    views_data = params[:views] || []

    # Use a transaction to ensure data consistency
    ActiveRecord::Base.transaction do
      views_data.each do |view_data|
        chapter_id = view_data[:chapter_id]
        views_count_delta = view_data[:views_count_delta].to_i

        # Skip if invalid data
        next if chapter_id.blank? || views_count_delta <= 0

        chapter = Chapter.find_by(id: chapter_id)
        next unless chapter

        # Update chapter views count with regular update to trigger callbacks and update timestamps
        chapter.update(views_count: chapter.views_count + views_count_delta)

        # Update related manga views count
        manga = chapter.translation.manga
        manga.update(views_count: manga.views_count + views_count_delta) if manga

        # Update related team views count
        team = chapter.translation.team
        team.update(views_count: team.views_count + views_count_delta) if team
      end
    end

    render(json: { status: 'success' })
  end
end
