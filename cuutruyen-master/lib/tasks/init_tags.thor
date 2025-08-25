# encoding: UTF-8

require 'thor'
require File.expand_path('config/environment.rb')

class InitTags < Thor
  desc "start", "TODO"
  def start
    create_tag 'oneshot', :common
    create_tag 'manga', :common
    create_tag 'manhua', :common
    create_tag 'manhwa', :common
    create_tag 'webtoon', :common
    create_tag 'đã hoàn thành', :common
    create_tag 'đang tiến hành', :common
    create_tag 'tạm ngưng', :common
    create_tag 'có màu', :common

    create_tag 'nsfw', :warning
    create_tag 'bạo lực', :warning
    create_tag 'khỏa thân', :warning
    create_tag 'lgbt', :warning

    create_tag 'shounen', :normal
    create_tag 'seinen', :normal
    create_tag 'romcom', :normal
    create_tag 'isekai', :normal
    create_tag 'kinh dị', :normal
    create_tag 'hài hước', :normal
    create_tag 'lãng mạn', :normal
    create_tag 'fantasy', :normal
    create_tag 'dark fantasy', :normal
    create_tag 'bí ẩn', :normal
    create_tag 'trinh thám', :normal
    create_tag 'quân đội', :normal
    create_tag 'hậu tận thế', :normal
    create_tag 'siêu nhiên', :normal
    create_tag 'sinh tồn', :normal
    create_tag 'du hành thời gian', :normal
    create_tag 'zombie', :normal
    create_tag 'phiêu lưu', :normal
    create_tag 'hành động', :normal
  end

  no_tasks do
    def create_tag name, type
      Tag.create(name: name, category: type, slug: name.to_url) unless Tag.exists?(name: name)
    end
  end
end
