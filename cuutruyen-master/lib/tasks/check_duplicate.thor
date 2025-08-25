require 'thor'

class CheckDuplicate < Thor
  desc "chapter CHAPTER_ID", "TODO"
  def chapter chapter_id
    require File.expand_path('config/environment.rb')

    puts "Started checking duplicates for chapter #{chapter_id}"

    Chapter.find(chapter_id).pages.where(status: :processed).order(:order).find_each do |page|
      puts "Chapter #{page.chapter.id} - Page #{page.id}:"

      # Check the files from s3
      # Prefix is the path to image directory of current page
      # Only taking derivatives (normal and scrambled files), to
      # not accidently delete the original file.
      page_storage_keys = Shrine.storages[:store].bucket
        .objects(prefix: "uploads/page/#{page.id}/image/")
        .map(&:key)
        .filter { |key| key.start_with?("uploads/page/#{page.id}/image/normal-") || key.start_with?("uploads/page/#{page.id}/image/scrambled-") }

      # Find using files in database
      page_used_keys = page.image_attacher.derivatives
        .map{ |k, v| v.id }
        .map{ |i| "uploads/#{i}" }

      # Filter to get unused files
      page_unused_keys = page_storage_keys - page_used_keys

      page_unused_keys.each do |key|
        Shrine.storages[:store].bucket.object(key).delete
        puts "+ DEL | #{key}"
      end

      puts "\n"
    end
  end

  desc "manga MANGA_ID", "TODO"
  def manga manga_id
    require File.expand_path('config/environment.rb')

    puts "Started checking duplicates for manga #{manga_id}"

    Manga.find(manga_id).pages.includes(:chapter).where(status: :processed).order(id: :desc).find_each do |page|
      puts "Manga #{manga_id} - Chapter #{page.chapter.id} - Page #{page.id}:"

      # Check the files from s3
      # Prefix is the path to image directory of current page
      # Only taking derivatives (normal and scrambled files), to
      # not accidently delete the original file.
      page_storage_keys = Shrine.storages[:store].bucket
        .objects(prefix: "uploads/page/#{page.id}/image/")
        .map(&:key)
        .filter { |key| key.start_with?("uploads/page/#{page.id}/image/normal-") || key.start_with?("uploads/page/#{page.id}/image/scrambled-") }

      # Find using files in database
      page_used_keys = page.image_attacher.derivatives
        .map{ |k, v| v.id }
        .map{ |i| "uploads/#{i}" }

      # Filter to get unused files
      page_unused_keys = page_storage_keys - page_used_keys

      page_unused_keys.each do |key|
        Shrine.storages[:store].bucket.object(key).delete
        puts "+ DEL | #{key}"
      end

      puts "\n"
    end
  end

  desc "page PAGE_ID", "TODO"
  def page page_id
    require File.expand_path('config/environment.rb')

    puts "Started checking duplicates for 1 month ago pages"

    # 2021/04/29 is the date the bug happend
    Page.includes(:chapter).where('id > ?', page_id).where(status: :processed).find_each do |page|
      puts "Chapter #{page.chapter.id} - Page #{page.id}:"

      # Check the files from s3
      # Prefix is the path to image directory of current page
      # Only taking derivatives (normal and scrambled files), to
      # not accidently delete the original file.
      page_storage_keys = Shrine.storages[:store].bucket
        .objects(prefix: "uploads/page/#{page.id}/image/")
        .map(&:key)
        .filter { |key| key.start_with?("uploads/page/#{page.id}/image/normal-") || key.start_with?("uploads/page/#{page.id}/image/scrambled-") }

      # Find using files in database
      page_used_keys = page.image_attacher.derivatives
        .map{ |k, v| v.id }
        .map{ |i| "uploads/#{i}" }

      # Filter to get unused files
      page_unused_keys = page_storage_keys - page_used_keys

      page_unused_keys.each do |key|
        Shrine.storages[:store].bucket.object(key).delete
        puts "+ DEL | #{key}"
      end

      puts "\n"
    end
  end
end
