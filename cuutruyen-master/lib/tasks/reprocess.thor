require 'thor'
require File.expand_path('config/environment.rb')

class Reprocess < Thor
  desc "chapter CHAPTER_ID", "TODO"
  def chapter chapter_id
    puts "Started reprocessing chapter #{chapter_id}"

    Chapter.find(chapter_id).pages.order(:order).find_each do |page|
      puts "got: #{page.chapter.id} - #{page.id}"
      page.update status: :processing
      attacher = page.image_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        page.update_status!(:processed)

        puts "done: #{page.chapter.id} - #{page.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: #{page.chapter.id} - #{page.id}"
      end

      GC.start
    end
  end

  desc "manga MANGA_ID", "TODO"
  option :from_page
  def manga manga_id
    puts "Started reprocessing manga #{manga_id}"

    query = Page.joins(chapter: :translation).where(chapters: {translations: {manga_id: manga_id}})
    query = query.where('pages.id >= ?', options[:from_page]) if options[:from_page].present?

    query.find_each do |page|
      puts "got: #{page.chapter.id} - #{page.id}"
      page.update status: :processing
      attacher = page.image_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        page.update status: :processed
        puts "done: #{page.chapter.id} - #{page.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: #{page.chapter.id} - #{page.id}"
      end

      GC.start
    end
  end

  desc "manga_size MANGA_ID", "TODO"
  option :from_page
  def manga_size manga_id
    puts "Started reprocessing manga #{manga_id}"
    query = Page.joins(chapter: {translation: :manga}).where(chapters: {translations: {manga_id: manga_id}})
    query = query.where('pages.id >= ?', options[:from_page]) if options[:from_page].present?

    query.find_each do |page|
      width = page.image(:normal)&.width
      height = page.image(:normal)&.height
      marginless = page.chapter.translation.manga.marginless
      if (width < height * 0.8 && width > 1024 && !marginless) ||
         (width > 768 && marginless)
        puts "got: #{page.chapter.id} - #{page.id}"
        attacher = page.image_attacher
        old_derivatives = attacher.derivatives

        attacher.set_derivatives({})
        attacher.create_derivatives

        begin
          attacher.atomic_persist
          attacher.delete_derivatives(old_derivatives)
          puts "done: #{page.chapter.id} - #{page.id}"
        rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
          attacher.delete_derivatives
          puts "nope: #{page.chapter.id} - #{page.id}"
        end

        GC.start
      else
        # puts "ignore: #{page.chapter.id} - #{page.id}"
      end
    end
  end

  desc "manga_cover", "TODO"
  def manga_cover
    puts "Started reprocessing ALL manga cover"

    Manga.kept.find_each do |m|
      puts "got: #{m.id}"
      attacher = m.cover_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        puts "done: #{m.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: #{m.id}"
      end
    end
  end

  desc "manga_panorama", "TODO"
  def manga_panorama
    puts "Started reprocessing ALL manga panorama"

    Manga.kept.find_each do |m|
      puts "got: #{m.id}"
      attacher = m.panorama_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        puts "done: #{m.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: #{m.id}"
      end
    end
  end

  desc "comment_content", "TODO"
  def comment_content
    Comment.all.find_each do |comment|
      comment.update_processed_content
    end
  end
end
