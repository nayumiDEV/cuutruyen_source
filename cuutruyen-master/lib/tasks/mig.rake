namespace :mig do
  desc "TODO"
  task title: :environment do
    Manga.find_each do |manga|
      manga.titles.create name: manga.name, primary: true
    end
  end
end
