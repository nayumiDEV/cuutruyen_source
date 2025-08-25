require "vips"

module SmartSplitter
  class Splitter
    attr_accessor :image, :max_color_threshold, :min_color_threshold, :per_page, :height_threshold

    def initialize(image, max_color_threshold, min_color_threshold, per_page, height_threshold)
      @image = image
      @max_color_threshold = max_color_threshold
      @min_color_threshold = min_color_threshold
      @per_page = per_page
      @height_threshold = height_threshold
    end

    def check_rows image
      projection = image.project[1]
      width = image.size[0]

      max_color_projection_threshold = 255 * width + @max_color_threshold
      min_color_projection_threshold = 0 + @min_color_threshold
      height_threshold = @height_threshold
      per_page = @per_page

      cut_rows = []
      x = per_page
      current_height = per_page

      while x < image.height
        px = projection.getpoint(0, x)

        if px[0] >= max_color_projection_threshold && px[1] >= max_color_projection_threshold && px[2] >= max_color_projection_threshold
          cut_rows.push x
          x += per_page
          current_height = per_page
        elsif px[0] <= min_color_projection_threshold && px[1] <= min_color_projection_threshold && px[2] <= min_color_projection_threshold
          cut_rows.push x
          x += per_page
          current_height = per_page
        elsif current_height >= height_threshold
          cut_rows.push x
          x += per_page
          current_height = per_page
        else
          x += 128
          current_height += 128
        end
      end

      cut_rows.push image.height

      cut_rows
    end

    def cut_row image, start_row, end_row, i
      crop_height = end_row - start_row
      cutted_image = image.extract_area 0, start_row, image.width, crop_height
      name = "%03d" % i
      file = Tempfile.new([name, '.jpg'])
      cutted_image.jpegsave(file.path, Q: 100, interlace: true, strip: true)
      file
    end

    def split
      rows = check_rows @image
      last_row = 0

      cutted_files = []

      for i in 0...rows.length
        cutted_file = cut_row @image, last_row, rows[i], i
        last_row = rows[i]
        cutted_files << cutted_file
      end

      cutted_files
    end
  end
end
