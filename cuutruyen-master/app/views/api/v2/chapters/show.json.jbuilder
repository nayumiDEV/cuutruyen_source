json.data do
  json.partial! 'api/v2/chapters/chapter', chapter: @chapter, manga: @manga, team: @team, pages: @pages
end
