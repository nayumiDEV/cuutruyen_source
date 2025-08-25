# frozen_string_literal: true

require 'vips'

module PageTrimmer
  class Trimmer
    attr_accessor :image, :fragments

    def initialize(image)
      @image = image
    end

    def trim_page
      im = @image
      # find the value of the pixel at (0, 0) ... we will search for all pixels
      # significantly different from this
      background = im.getpoint(0, 0)

      # we need to smooth the image, subtract the background from every pixel, take
      # the absolute value of the difference, then threshold
      mask = (im.median - background).abs > 10

      # sum mask rows and columns, then search for the first non-zero sum in each
      # direction
      columns, rows = mask.project

      _first_column, first_row = columns.profile
      left = first_row.min

      _first_column, first_row = columns.fliphor.profile
      right = columns.width - first_row.min

      first_column, _first_row = rows.profile
      top = first_column.min

      first_column, _first_row = rows.flipver.profile
      bottom = rows.height - first_column.min

      # and now crop the original image
      begin
        im2 = im.crop(left, top, right - left, bottom - top)
      rescue Vips::Error
        im
      end
    end
  end
end
