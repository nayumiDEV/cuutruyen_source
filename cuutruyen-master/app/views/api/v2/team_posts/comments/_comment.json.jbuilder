json.id comment.id
json.user do
  json.id comment.user.id
  json.username comment.user.username
  json.teams comment.user.teams do |team|
    json.id team.id
    json.name team.name
  end
  json.level comment.user.level
end
json.processed_content comment.processed_content
if comment.remover.present?
  json.remover do
    json.username comment.remover.username
    json.teams comment.remover.teams do |team|
      json.id team.id
      json.name team.name
    end
    json.level comment.user.level
  end
  json.remove_reason comment.remove_reason
  json.removed_at comment.removed_at
end
json.is_shadow_removed comment.is_shadow_removed
json.created_at comment.created_at
json.replied_ids comment.replieds.pluck(:id)
