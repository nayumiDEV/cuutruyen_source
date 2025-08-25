# frozen_string_literal: true

require 'image_processing/vips'
require 'image_optim'

class CoverUploader < Shrine
  plugin(:color)
  plugin(:store_dimensions, analyzer: :ruby_vips)

  if Rails.env.production?
    plugin(:url_options, store: { host: 'https://storage-ct.lrclib.net/file/cuutruyen/', public: true })
  else
    plugin(:url_options, store: { host: 'http://cuutruyen.localhost', public: true })
  end

  Attacher.validate do
    validate_max_size 50.megabytes
    validate_mime_type %w[image/jpeg image/png image/webp]
  end

  add_metadata(:dominant_color) do |io, _context|
    Shrine.with_file(io) do |file|
      Miro::DominantColors.new(file.path).to_hex.first
    end
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    processed_image = vips
      .resize_to_fill(224, 336, crop: :centre)
      .convert('jpg')
      .saver(interlace: true, quality: 95, strip: true)
      .call

    processed_mobile_image = vips
      .resize_to_fill(128, 192, crop: :centre)
      .convert('jpg')
      .saver(interlace: true, quality: 92, strip: true)
      .call

    { processed: processed_image, processed_mobile: processed_mobile_image }
  end
end
