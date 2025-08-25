json.data do
  json.common_tags do
    json.partial! 'api/v2/tags/tag', collection: @common_tags, as: :tag
  end

  json.warning_tags do
    json.partial! 'api/v2/tags/tag', collection: @warning_tags, as: :tag
  end

  json.normal_tags do
    json.partial! 'api/v2/tags/tag', collection: @normal_tags, as: :tag
  end
end
