namespace :re do
  desc "TODO"

  task p33665: :environment do
    page = Page.find(33665)

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
  end

  task ch1252: :environment do
    Chapter.find(1252).pages.order(:order).find_each do |page|
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
    end
  end

  task m16: :environment do
    Manga.find(16).pages.order(:order).find_each do |page|
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
    end
  end

  task page: :environment do
    Chapter.all.find_each do |c|
      c.pages.find_each do |page|
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
      end
    end
  end

  task cover: :environment do
    Manga.where(id: 159).find_each do |m|
      puts "got: m#{m.id}"
      attacher = m.cover_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        puts "done: m#{m.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: m#{m.id}"
      end
    end
  end

  task panorama: :environment do
    Manga.where(id: 159).find_each do |m|
      puts "got: m#{m.id}"
      attacher = m.panorama_attacher
      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
        puts "done: m#{m.id}"
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
        puts "nope: m#{m.id}"
      end
    end
  end
end
