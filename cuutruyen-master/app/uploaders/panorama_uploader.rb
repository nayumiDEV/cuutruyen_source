# frozen_string_literal: true

require 'image_processing/vips'
require 'image_optim'

class PanoramaUploader < Shrine
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

  add_metadata do |io, _context|
    Shrine.with_file(io) do |file|
      hexes = Miro::DominantColors.new(file.path).to_hex

      {
        'dominant_color' => hexes.first,
        'dominant_color_2' => hexes.last
      }
    end
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    processed_image = vips
      .resize_to_fill(1280, 600, crop: :centre)
      .convert('jpg')
      .saver(interlace: true, quality: 87, strip: true)
      .call

    processed_mobile_image = vips
      .resize_to_fill(640, 300, crop: :centre)
      .convert('jpg')
      .saver(interlace: true, quality: 83, strip: true)
      .call

    { processed: processed_image, processed_mobile: processed_mobile_image }
  end
end
