json.data do
  json.partial! 'api/v2/mangas/manga', manga: @manga, team: @team, translation: @translation, is_following: @is_following
end
