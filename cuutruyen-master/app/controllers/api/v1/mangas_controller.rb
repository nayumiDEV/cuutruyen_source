# frozen_string_literal: true

class Api::V1::MangasController < ApplicationController
  def index
    mangas = MangaResource.all(params)
    render(jsonapi: mangas)
  end

  def show
    manga = MangaResource.find(params)
    render(jsonapi: manga)
  end

  def create
    manga = MangaResource.build(params)

    if manga.save
      render(jsonapi: manga, status: 201)
    else
      render(jsonapi_errors: manga)
    end
  end

  def update
    manga = MangaResource.find(params)

    if manga.update_attributes
      render(jsonapi: manga)
    else
      render(jsonapi_errors: manga)
    end
  end

  def destroy
    manga = MangaResource.find(params)

    if manga.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: manga)
    end
  end
end
