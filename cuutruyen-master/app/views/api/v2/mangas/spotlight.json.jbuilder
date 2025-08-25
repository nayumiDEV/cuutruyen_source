json.data do
  json.partial! 'api/v2/mangas/spotlight_manga', collection: @mangas, as: :manga
end
