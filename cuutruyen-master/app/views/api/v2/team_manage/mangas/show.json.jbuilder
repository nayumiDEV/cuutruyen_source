json.data do
  json.partial! 'api/v2/team_manage/mangas/manga', manga: @manga, team: @team, translation: @translation
end
