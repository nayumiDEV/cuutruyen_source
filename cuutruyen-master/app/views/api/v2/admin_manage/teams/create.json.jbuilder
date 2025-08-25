json.status :success
json.message 'Đã thêm nhóm mới thành công!'
json.data do
  json.partial! 'api/v2/admin_manage/teams/team', team: @team
end
