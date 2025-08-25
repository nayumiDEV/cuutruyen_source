namespace :mv do
  desc "TODO"

  task page: :environment do
    Page.where('id >= ?', 22140).find_each do |page|
      puts "got: page #{page.id}"
      attacher = page.image_attacher

      next unless attacher.stored?

      attacher.file.trigger_mirror_upload
      attacher.map_derivative(attacher.derivatives) do |_, derivative|
        derivative.trigger_mirror_upload
      end

      puts "done: page #{page.id}"
    end
  end

  task manga: :environment do
    Manga.find_each do |manga|
      puts "got: manga #{manga.id}"
      cover_attacher = manga.cover_attacher
      panorama_attacher = manga.panorama_attacher

      next unless cover_attacher.stored? && panorama_attacher.stored?

      cover_attacher.file.trigger_mirror_upload
      cover_attacher.map_derivative(cover_attacher.derivatives) do |_, derivative|
        derivative.trigger_mirror_upload
      end

      panorama_attacher.file.trigger_mirror_upload
      panorama_attacher.map_derivative(panorama_attacher.derivatives) do |_, derivative|
        derivative.trigger_mirror_upload
      end

      puts "done: manga #{manga.id}"
    end
  end
end
