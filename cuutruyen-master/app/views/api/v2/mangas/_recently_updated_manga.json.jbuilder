json.id manga.id
json.name manga.primary_title&.name
json.cover_url manga.cover(:processed)&.url
json.cover_mobile_url manga.cover(:processed_mobile)&.url
json.newest_chapter_number manga.newest_chapter&.number
json.newest_chapter_id manga.newest_chapter&.id
json.newest_chapter_created_at manga.newest_chapter&.created_at
