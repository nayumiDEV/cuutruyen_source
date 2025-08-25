# frozen_string_literal: true
class Api::V1::UsersFollowMangasController < ApplicationController
  def index
    users_follow_mangas = UserFollowMangaResource.all(params)
    render(jsonapi: users_follow_mangas)
  end

  def show
    users_follow_manga = UserFollowMangaResource.find(params)
    render(jsonapi: users_follow_manga)
  end

  def create
    users_follow_manga = UserFollowMangaResource.build(params)

    if users_follow_manga.save
      render(jsonapi: users_follow_manga, status: 201)
    else
      render(jsonapi_errors: users_follow_manga)
    end
  end

  def update
    users_follow_manga = UserFollowMangaResource.find(params)

    if users_follow_manga.update_attributes
      render(jsonapi: users_follow_manga)
    else
      render(jsonapi_errors: users_follow_manga)
    end
  end

  def destroy
    users_follow_manga = UserFollowMangaResource.find(params)

    if users_follow_manga.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: users_follow_manga)
    end
  end
end
