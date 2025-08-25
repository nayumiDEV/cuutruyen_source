json.id manga.id
json.translation do
  json.id manga&.translation&.id
end
json.name manga.primary_title&.name
json.cover manga.cover
json.cover_url manga.cover(:processed)&.url
json.cover_mobile_url manga.cover(:processed_mobile)&.url
json.cover_original_url manga.cover&.url
json.panorama manga.panorama
json.panorama_url manga.panorama(:processed)&.url
json.panorama_mobile_url manga.panorama(:processed_mobile)&.url
json.panorama_original_url manga.panorama&.url
json.newest_chapter_number manga&.newest_chapter&.number
json.newest_chapter_id manga&.newest_chapter&.id
json.newest_chapter_created_at manga&.newest_chapter&.created_at
json.author do
  json.name manga&.author&.name
end
json.description manga.description
json.full_description manga.full_description
json.official_url manga.official_url
json.is_region_limited manga.is_region_limited
json.chapters_count manga&.translation&.chapters_count
json.views_count manga.views_count
json.direction manga.direction
json.marginless manga.marginless
json.tags_list manga.tags_list

json.titles manga.titles do |title|
  json.id title.id
  json.name title.name
  json.primary title.primary
end

json.team do
  json.id manga&.translation&.team&.id
  json.name manga&.translation&.team&.name
end

json.created_at manga.created_at
json.updated_at manga.updated_at
