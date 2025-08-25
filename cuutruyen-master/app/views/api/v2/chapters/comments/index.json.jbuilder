json.data do
  json.cache! ['v6', @commentable, :comments] do
    json.array! @comments, partial: 'api/v2/chapters/comments/comment', as: :comment, cached: true
  end
end
