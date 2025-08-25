require 'redis'

class ViewsCounter
  def initialize
    @redis = Redis.new(url: ENV.fetch("REDIS_URL") { "redis://redis:6379/1" })
  end

  def persist_views_count
    mangas_data = @redis.hgetall get_key_string(:manga)
    mangas_data.each do |id, views_count|
      views_count = views_count.to_i
      if views_count > 500
        manga = Manga.find_by(id: id)
        if manga
          manga.update views_count: manga.views_count + views_count
          @redis.hdel get_key_string(:manga), id
        else
          @redis.hdel get_key_string(:manga), id
        end
      end
    end

    chapters_data = @redis.hgetall get_key_string(:chapter)
    chapters_data.each do |id, views_count|
      views_count = views_count.to_i
      if views_count > 100
        chapter = Chapter.find_by(id: id)
        if chapter
          chapter.update views_count: chapter.views_count + views_count
          @redis.hdel get_key_string(:chapter), id
        else
          @redis.hdel get_key_string(:chapter), id
        end
      end
    end

    teams_data = @redis.hgetall get_key_string(:team)
    teams_data.each do |id, views_count|
      views_count = views_count.to_i
      if views_count > 1000
        team = Team.find_by(id: id)
        if team
          team.update_column :views_count, team.views_count + views_count
          @redis.hdel get_key_string(:team), id
        else
          @redis.hdel get_key_string(:team), id
        end
      end
    end

    true
  end

  def get_views_count model
    model_type = get_model_type model
    @redis.hget(get_key_string(model_type), model.id).to_i
  end

  def increment chapter
    translation = chapter.translation
    manga = translation.manga
    team = translation.team

    increment_model @redis, chapter
    increment_model @redis, manga
    increment_model @redis, team
  end

  private

  def increment_model pipeline, model
    model_type = get_model_type model

    if is_exists?(pipeline, model_type, model.id)
      increase_views_count(pipeline, model_type, model.id)
    else
      set_views_count(pipeline, model_type, model.id, 1)
    end
  end

  def is_exists? pipeline, type, id
      pipeline.hexists(get_key_string(type), id)
  end

  def set_views_count pipeline, type, id, value
      pipeline.hset(get_key_string(type), id, value)
  end

  def increase_views_count pipeline, type, id
      pipeline.hincrby(get_key_string(type), id, 1)
  end

  def get_model_type model
    model.class.name.underscore.to_sym
  end

  def get_key_string type
    "v2/view_counter/#{type}"
  end
end
