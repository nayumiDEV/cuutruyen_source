require 'zip'

Zip.setup do |c|
  c.on_exists_proc = true
  c.continue_on_exists_proc = true
end

class ChapterCompressor
  attr_accessor :chapter_id

  def initialize(chapter)
    @chapter = chapter
  end

  def generate_zip_file
    manga_title = Manga.find(@chapter.translation.manga.id).titles.where(primary: true).first
    zip_file = Tempfile.new(["#{manga_title}_chapter_#{@chapter.number}_i", '.zip'])

    tempfiles = []

    Zip::File.open(zip_file.path, Zip::File::CREATE) do |f|
      @chapter.pages.each do |page|
        p page
        image = page.image(:normal)
        page_number = page.order.to_s.rjust(3, '0')
        image_extension = image.metadata['filename'].split('.').last
        # image_path = Rails.root.join('public', 'uploads', image.id)
        tempfile = image.download
        tempfiles << tempfile
        p tempfile.path
        output_filename = "#{page_number}.#{image_extension}"

        p output_filename
        p tempfile.path
        f.add(output_filename, tempfile.path)
        puts "done\n"
      end
    end

    p "done"
    Shrine.upload(File.open(zip_file.path), :cache)
  end
end
