json.data do
  json.same_team_mangas do
    json.partial! 'api/v2/mangas/top_manga', collection: @rand_top_team_mangas, as: :manga
  end

  json.suggested_mangas do
    json.partial! 'api/v2/mangas/top_manga', collection: @rand_top_mangas, as: :manga
  end
end
