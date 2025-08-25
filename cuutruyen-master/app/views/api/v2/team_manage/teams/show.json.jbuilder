json.data do
  json.partial! 'api/v2/team_manage/teams/team', team: @current_team
end
