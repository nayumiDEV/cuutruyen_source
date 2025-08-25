# frozen_string_literal: true

require "#{Rails.root}/lib/scramble_page"
require "#{Rails.root}/lib/page_trimmer"

class ImageUploader < Shrine
  plugin(:color)
  plugin(:store_dimensions, analyzer: :ruby_vips)

  Attacher.promote_block do
    PagePromoteJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
  end

  Attacher.validate do
    validate_max_size 50.megabytes, message: 'Kích thước tối đa của hình phải dưới 50 MB'
    validate_mime_type %w[image/jpeg image/png image/webp], message: 'Chỉ chấp nhận định dạng JPG, PNG, hoặc WEBP'
    validate_max_width 8000, message: 'Chiều rộng của hình phải dưới 8000 px'
    validate_max_height 8000, message: 'Chiều dài của hình phải dưới 8000 px'
  end

  Attacher.derivatives do |original|
    vips_image = nil
    if record.chapter.translation.manga.marginless
      vips_image = Vips::Image.new_from_file(original.path)
                     .thumbnail_image(768, height: 100000, size: :down)
    else
      vips_image = Vips::Image.new_from_file(original.path)
      width = vips_image.size[0]
      height = vips_image.size[1]

      vips_image = if width < height * 0.8
                     vips_image.thumbnail_image(1024, height: 100000, size: :down)
                   else
                     vips_image.thumbnail_image(2048, height: 100000, size: :down)
                   end
    end

    normal_file = Tempfile.new(['normal', '.jpg'])
    vips_image.jpegsave(normal_file.path, Q: 95, interlace: true, strip: true)

    scrambled_file = Tempfile.new(['scrambled', '.jpg'])
    scrambler = ::ScramblePage::Scrambler.new(vips_image).get_scrambled(150)
    record.drm_data = scrambler[:drm_data]
    record.drm_data_raw = scrambler[:drm_data_raw]
    scrambler[:image].jpegsave(scrambled_file.path, Q: 92, optimize_coding: true, no_subsample: true, interlace: true, strip: true)

    { normal: normal_file, scrambled: scrambled_file }
  end
end
