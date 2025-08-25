json.data do
  json.mangas do
    json.partial! 'api/v2/mangas/thumb_manga', collection: @mangas, as: :manga
  end
  json.tag do
    json.partial! 'api/v2/tags/tag', tag: @tag
  end
end

json._metadata do
  json.total_count @pagy.count
  json.total_pages @pagy.pages
  json.current_page @pagy.page
  json.per_page @pagy.items
end
