json.id team.id
json.name team.name
json.slug team.slug
json.description team.description
json.facebook_address team.facebook_address
json.main_page_blocks team.main_page_blocks
json.translations_count team.translations_count
json.views_count team.views_count
json.team_members do
  json.array! team.team_members do |team_member|
    json.id team_member.id
    json.user_id team_member.user_id
    json.username team_member.user.username
    json.email team_member.user.masked_email
    json.role team_member.role
    json.created_at team_member.created_at
  end
end
json.created_at team.created_at
json.avatar_url team.avatar(:processed)&.url || team.avatar&.url
