json.data do
  json.partial! 'api/v2/mangas/top_manga', collection: @mangas, as: :manga
end
