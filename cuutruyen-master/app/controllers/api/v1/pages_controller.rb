# frozen_string_literal: true
class Api::V1::PagesController < ApplicationController
  def index
    pages = PageResource.all(params)
    render(jsonapi: pages)
  end

  def show
    page = PageResource.find(params)
    render(jsonapi: page)
  end

  def create
    page = PageResource.build(params)

    if page.save
      render(jsonapi: page, status: 201)
    else
      render(jsonapi_errors: page)
    end
  end

  def update
    page = PageResource.find(params)

    if page.update_attributes
      render(jsonapi: page)
    else
      render(jsonapi_errors: page)
    end
  end

  def destroy
    page = PageResource.find(params)

    if page.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: page)
    end
  end
end
