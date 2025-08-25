# frozen_string_literal: true
class Api::V1::TitlesController < ApplicationController
  def index
    titles = TitleResource.all(params)
    render(jsonapi: titles)
  end

  def show
    title = TitleResource.find(params)
    render(jsonapi: title)
  end

  def create
    title = TitleResource.build(params)

    if title.save
      render(jsonapi: title, status: 201)
    else
      render(jsonapi_errors: title)
    end
  end

  def update
    title = TitleResource.find(params)

    if title.update_attributes
      render(jsonapi: title)
    else
      render(jsonapi_errors: title)
    end
  end

  def destroy
    title = TitleResource.find(params)

    if title.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: title)
    end
  end
end
