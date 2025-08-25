require 'thor'
require File.expand_path('config/environment.rb')
require "#{Rails.root}/lib/smart_splitter"

class Split < Thor
  desc "chapter CHAPTER_ID", "TODO"
  def chapter chapter_id
    puts "Started image splitting chapter #{chapter_id}"

    chapter = Chapter.find(chapter_id)
    chapter.pages.order(:order).each do |page|
      page.reload
      tempfile = page.image.download
      vips_image = Vips::Image.new_from_file(tempfile.path)

      filename = page.image.metadata["filename"]
      basename = File.basename(filename, ".*")
      extname = File.extname(filename)

      # pass image to splitter
      splitter = SmartSplitter::Splitter.new(vips_image, -10, 10, 600, 5000)
      result_files = splitter.split
      result_count = result_files.size

      if result_count > 1
        ActiveRecord::Base.transaction do
          # increase order of pages behind
          behind_pages = chapter.pages.where(Page.arel_table[:order].gt(page.order))
          behind_pages.each do |behind_page|
            behind_page.increment! :order, result_count - 1
          end

          # add new page to this chapter
          current_order = page.order
          result_files.each.with_index do |file, index|
            name = "%02d" % index
            uploaded_file = ImageUploader.upload(file, :cache, metadata: { "filename": "#{basename}-#{name}#{extname}" })
            chapter.pages.create! order: current_order, image: uploaded_file
            current_order += 1
          end

          # delete old page
          page.destroy!
        end
      end

      GC.start
    end
  end
end
