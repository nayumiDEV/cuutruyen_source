json.id user.id
json.username user.username
json.email user.email
json.level user.level
if user.user_ban.present?
  json.user_ban do
    json.ban_type user.user_ban.ban_type
    json.banned_until user.user_ban.banned_until
    json.reason user.user_ban.reason
  end
end
json.created_at user.created_at
