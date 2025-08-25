json.data do
  json.partial! 'api/v2/team_posts/comments/comment', collection: @comments, cached: true, as: :comment
end
