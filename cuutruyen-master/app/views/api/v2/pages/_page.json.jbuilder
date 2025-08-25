require 'base64'
require "#{Rails.root}/lib/xorob"
require 'uri'

json.id page.id
json.order page.order
json.width page.image(:normal)&.width
json.height page.image(:normal)&.height
json.status page.status
json.image_url page.image(:scrambled)&.url
if Rails.env.production? && page.image(:scrambled)&.url.present?
  json.image_path URI::parse(page.image(:scrambled).url).path
end
json.image_url_size page.image(:scrambled)&.size
json.drm_data page.drm_data_dyn
