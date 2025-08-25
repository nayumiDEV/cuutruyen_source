class Api::V2::TagsController < Api::V2::BaseController
  def popular
    @common_tags = Tag.where(category: :common).order(:name)
    @warning_tags = Tag.where(category: :warning).order(:name)
    @normal_tags = Tag.where(category: :normal).order(tagging_count: :desc).limit(20)
  end

  def search
    @keyword = params[:q]
    @tags = Tag.search(@keyword, limit: 20)
  end

  def show
    @tag = Tag.find_by slug: params[:slug]
    raise NotFoundError, 'Tag không tồn tại' unless @tag
    @pagy, @mangas = pagy(@tag.mangas.kept.includes(:author, :newest_chapter, :primary_title).joins_newest_chapter.where(status: :processed).has_chapter(true).order('newest_chapter.created_at': :desc), items: per_page)
  end
end
