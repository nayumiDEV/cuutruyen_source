# frozen_string_literal: true

require 'faker'

ActiveRecord::Base.transaction do
  puts "Seed users..."

  User.create!(username: 'tranxuanthang',
               email: 'tranthang.yb@outlook.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'cauvang',
               email: 'cauvang@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'laohac',
               email: 'laohac@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'cuudolly',
               email: 'cuudolly@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'bachtuyet',
               email: 'bachtuyet@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'sontinh',
               email: 'sontinh@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'thuytinh',
               email: 'thuytinh@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  User.create!(username: 'onggiao',
               email: 'ongiao@gmail.com',
               password: '123456',
               password_confirmation: '123456')

  puts "Seed authors..."

  5.times do
    Author.create!(name: Faker::Book.author,
                   description: Faker::Lorem.paragraph)
  end

  puts "Seed teams..."

  5.times do
    Team.new(name: Faker::Team.name,
                 description: Faker::Lorem.paragraph).save!(:validate => false)
  end

  puts "Seed team_members..."

  Team.all.each do |team|
    3.times do
      offset = rand(User.count)
      rand_user = User.offset(offset).first
      TeamMember.create!(team: team,
                         user: rand_user,
                         role: :owner)
    end
  end

  puts "Seed mangas..."

  23.times do
    offset = rand(Author.count)
    rand_author = Author.offset(offset).first
    title = Faker::Book.title
    m = Manga.create!(
      name: title,
      description: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 1),
      full_description: Faker::Lorem.paragraphs.join("\n\n"),
      author: rand_author,
      cover_remote_url: Faker::LoremFlickr
        .image(size: '320x480', search_terms: %w[manga cover], match_all: true),
      panorama_remote_url: Faker::LoremFlickr
        .image(size: '1024x480', search_terms: %w[river], match_all: true),
      focus_x: 50,
      focus_y: 50,
      titles_attributes: [
        { name: title, primary: true }
      ]
    )
    t = m.titles.create! name: title, primary: true
    m.update primary_title: t
  end

  puts "Seed translations..."

  Manga.all.each do |manga|
    offset = rand(Team.count)
    rand_team = Team.offset(offset).first

    Translation.create!(language: %w[vi en].sample,
                        team: rand_team,
                        manga: manga)
  end

  puts "Seed chapters..."

  Translation.all.each do |translation|
    Chapter.create!(translation: translation,
                   number: '1',
                   order: 0,
                   name: 'First chapter')
    Chapter.create!(translation: translation,
                   number: '2',
                   order: 1,
                   name: 'Second chapter')
  end

  puts "Seed pages..."

  chapter = Chapter.first
  chapter2 = Chapter.second

  Page.create!(chapter: chapter,
               order: 0,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[manga], match_all: true))

  Page.create!(chapter: chapter,
               order: 1,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[sparta], match_all: true))

  Page.create!(chapter: chapter,
               order: 2,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[movie], match_all: true))

  Page.create!(chapter: chapter,
               order: 3,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[home], match_all: true))

  Page.create!(chapter: chapter2,
               order: 0,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[skyrim], match_all: true))

  Page.create!(chapter: chapter2,
               order: 1,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[warcraft], match_all: true))

  Page.create!(chapter: chapter2,
               order: 2,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[fight club], match_all: true))

  Page.create!(chapter: chapter2,
               order: 3,
               image_remote_url: Faker::LoremFlickr
                 .image(size: '709x1035', search_terms: %w[courage dog], match_all: true))

  puts "Seed comments..."

  Page.all.each do |page|
    rand(35).times do
      offset = rand(User.count)
      rand_user = User.offset(offset).first

      Comment.create!(
        user: rand_user,
        page: page,
        chapter: page.chapter,
        translation: page.chapter.translation,
        content: Faker::Quote.famous_last_words,
      )
    end
  end
end
