namespace :orig do
  desc "TODO"
  task cover: :environment do
    Manga.kept.find_each do |m|
      puts "got: m#{m.id}"
      original = m.cover
      processed = m.cover(:processed)

      next unless original && processed

      uploaded_file = m.cover_attacher.upload processed,
        metadata: { "filename" => original["filename"] },
        delete: true

      m.cover_attacher.set(uploaded_file)
      m.save
      original.delete
      puts "done: m#{m.id}"
    end
  end

  task panorama: :environment do
    Manga.kept.find_each do |m|
      puts "got: m#{m.id}"
      original = m.panorama
      processed = m.panorama(:processed)

      next unless original && processed

      uploaded_file = m.panorama_attacher.upload processed,
        metadata: { "filename" => original["filename"] },
        delete: true

      m.panorama_attacher.set(uploaded_file)
      m.save
      original.delete
      puts "done: m#{m.id}"
    end
  end

  task page: :environment do
    Page.all.find_each do |p|
      # puts "got: p#{p.id}"
      original = p.image
      processed = p.image(:normal)

      next unless original && processed

      uploaded_file = p.image_attacher.upload processed,
        metadata: { "filename" => original["filename"] },
        delete: true

      p.image_attacher.set(uploaded_file)
      p.save
      original.delete
      puts "done: p#{p.id}"
    end
  end

  task ch1119: :environment do
    Chapter.find(1119).pages.find_each do |p|
      # puts "got: p#{p.id}"
      original = p.image
      processed = p.image(:normal)

      next unless original && processed

      uploaded_file = p.image_attacher.upload processed,
        metadata: { "filename" => original["filename"] },
        delete: true

      p.image_attacher.set(uploaded_file)
      p.save
      original.delete
      puts "done: p#{p.id}"
    end
  end
end
