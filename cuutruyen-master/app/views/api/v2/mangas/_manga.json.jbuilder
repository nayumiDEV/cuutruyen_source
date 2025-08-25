json.id manga.id
json.name manga.primary_title&.name
json.cover_url manga.cover(:processed)&.url
json.cover_mobile_url manga.cover(:processed_mobile)&.url
json.panorama_url manga.panorama(:processed)&.url
json.panorama_mobile_url manga.panorama(:processed_mobile)&.url
json.panorama_dominant_color manga.panorama_dominant_color
json.panorama_dominant_color_2 manga.panorama_dominant_color_2
json.newest_chapter_number manga.newest_chapter&.number
json.newest_chapter_id manga.newest_chapter&.id
json.newest_chapter_created_at manga.newest_chapter&.created_at
json.author do
  json.name manga.author.name
end
json.description manga.short_description
json.full_description manga.full_description_2
json.official_url manga.official_url
json.is_region_limited manga.is_region_limited
json.is_ads team.is_ads
json.chapters_count @translation.chapters_count
json.views_count manga.views_count
json.is_nsfw manga.is_nsfw

json.tags manga.tags do |tag|
  json.name tag.name
  json.slug tag.slug
  json.tagging_count tag.tagging_count
end

if team.present?
  json.team do
    json.partial! 'api/v2/teams/team', team: team
  end
end

json.is_following is_following

json.titles manga.titles do |title|
  json.id title.id
  json.name title.name
  json.primary title.primary
end

json.created_at manga.created_at
json.updated_at manga.updated_at
