json.data do
  json.partial! 'api/v2/admin_manage/users/user', collection: @users, as: :user
end
json._metadata do
  json.total_count @pagy.count
  json.total_pages @pagy.pages
  json.current_page @pagy.page
  json.per_page @pagy.items
end
