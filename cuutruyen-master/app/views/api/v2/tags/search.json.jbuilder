json.data do
  json.partial! 'api/v2/tags/tag', collection: @tags, as: :tag
end
