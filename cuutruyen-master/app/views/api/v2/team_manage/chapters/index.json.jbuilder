json.data do
  json.partial! 'api/v2/team_manage/chapters/chapter', collection: @chapters, as: :chapter
end
