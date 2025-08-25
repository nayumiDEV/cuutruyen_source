# frozen_string_literal: true

require 'vips'
require 'base64'
require "#{Rails.root}/lib/xorob"

module ScramblePage
  class Scrambler
    attr_accessor :image, :fragments

    def initialize(image)
      @image = image
    end

    def split_image(base_fragment_height = 200)
      fragments = []

      height = @image.height
      width = @image.width

      number_fragment = height / base_fragment_height

      number_fragment.times do |n|
        y_start = n * base_fragment_height
        fragment_image = image.crop(0, y_start, width, base_fragment_height)

        fragments.push(
          {
            image: fragment_image,
            info: {
              y: y_start,
              height: base_fragment_height
            }
          }
        )
      end

      if number_fragment * base_fragment_height < height
        y_start = number_fragment * base_fragment_height
        left_height = height - y_start
        fragment_image = image.crop(0, y_start, width, left_height)

        fragments.push(
          {
            image: fragment_image,
            info: {
              y: y_start,
              height: left_height
            }
          }
        )
      end

      fragments
    end

    def shuffle_fragments(fragments)
      fragments.shuffle
    end

    def get_scrambled(base_fragment_height = 200)
      fragments = split_image(base_fragment_height)
      shuffled = shuffle_fragments(fragments)

      scrambled_image = shuffled[1..-1].reduce(shuffled.first[:image]) do |acc, f|
        acc.join(f[:image], :vertical)
      end

      info = shuffled.map { |f| f[:info] }
        .map { |f| "#{f[:y]}-#{f[:height]}" }.join('|')

      xored = Xorob::xor_string(info, (Math::PI * (10**15)).round.to_s)
      encrypted_info = Base64.encode64(xored)
      { drm_data: encrypted_info, drm_data_raw: info, image: scrambled_image }
    end
  end
end
