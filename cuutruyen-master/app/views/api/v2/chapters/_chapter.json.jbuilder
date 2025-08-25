json.id chapter.id
json.order chapter.order
json.number chapter.number
json.name chapter.name
json.views_count chapter.views_count
json.comments_count chapter.comments_count
json.status chapter.status
json.previous_chapter_id chapter.previous_chapter_id
json.previous_chapter_number chapter.previous_chapter_number
json.previous_chapter_name chapter.previous_chapter_name
json.next_chapter_id chapter.next_chapter_id
json.next_chapter_number chapter.next_chapter_number
json.next_chapter_name chapter.next_chapter_name
json.created_at chapter.created_at
json.updated_at chapter.updated_at

json.manga do
  json.cache! ['v6', manga] do
    json.id manga.id
    json.name manga.primary_title&.name
    json.description manga.description
    json.cover_url manga.cover(:processed)&.url
    json.cover_mobile_url manga.cover(:processed_mobile)&.url
    json.panorama_url manga.panorama(:processed)&.url
    json.panorama_mobile_url manga.panorama(:processed_mobile)&.url
    json.marginless manga.marginless
    json.is_region_limited manga.is_region_limited
    json.direction manga.direction
    json.is_nsfw manga.is_nsfw
  end
end

json.team do
  json.cache! ['v6', team] do
    json.id team.id
    json.name team.name
    json.description team.description
    json.facebook_address team.facebook_address
    json.is_ads team.is_ads
    json.translations_count team.translations_count
    json.mangas_count team.translations_count
  end
end

json.pages do
  json.cache! ['v6', chapter, :pages] do
    json.array! pages, partial: 'api/v2/pages/page', as: :page, cached: true
  end
end
