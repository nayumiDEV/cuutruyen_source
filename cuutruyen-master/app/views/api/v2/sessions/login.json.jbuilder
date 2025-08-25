json.data do
  json.partial! 'api/v2/users/user', user: @user
end
json.version 2
json.auth_token @user.auth_token
