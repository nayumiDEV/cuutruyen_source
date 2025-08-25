# frozen_string_literal: true

class AbitraryPhotoUploader < Shrine
  plugin(:store_dimensions, analyzer: :ruby_vips)

  Attacher.validate do
    validate_max_size 10.megabytes
    validate_mime_type %w[image/jpeg image/png image/webp]
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    processed_image = vips
      .resize_to_limit(1500, 1500)
      .convert('jpg')
      .saver(interlace: true, quality: 87, strip: true)
      .call

    { processed: processed_image }
  end
end
