json.data do
  json.cache! ['v6', @manga, :chapters] do
    json.array! @chapters, partial: 'api/v2/chapters/list_item_chapter', as: :chapter, cached: true
  end
end
