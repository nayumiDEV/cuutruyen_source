json.id team.id
json.slug team.slug || "+#{team.id}"
json.name team.name
json.description team.description
json.is_ads team.is_ads
json.facebook_address team.facebook_address
json.views_count team.views_count
json.translations_count team.translations_count
json.created_at team.created_at
json.updated_at team.updated_at
json.main_page_blocks team.main_page_blocks
json.avatar_url team.avatar(:processed)&.url || team.avatar&.url
