json.data do
  json.spotlight_mangas do
    json.partial! 'api/v2/mangas/spotlight_manga', collection: @spotlight_mangas, as: :manga
  end
  json.new_chapter_mangas do
    json.partial! 'api/v2/mangas/recently_updated_manga', collection: @new_chapter_mangas, as: :manga
  end
end
