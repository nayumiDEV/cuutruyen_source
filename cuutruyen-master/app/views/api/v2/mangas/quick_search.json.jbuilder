json.data do
  json.partial! 'api/v2/mangas/thumb_manga', collection: @mangas, as: :manga
end
