class Api::V2::TeamManage::TagsController < Api::V2::TeamManage::BaseController
  def search
    @keyword = params[:q]
    @tags = Tag.search(@keyword, limit: 5)
  end
end
