json.id manga.id
json.name manga.primary_title&.name
json.panorama_url manga.panorama(:processed)&.url
json.panorama_mobile_url manga.panorama(:processed_mobile)&.url
json.panorama_dominant_color manga.panorama_dominant_color
json.panorama_dominant_color_2 manga.panorama_dominant_color_2
json.description manga.short_description
