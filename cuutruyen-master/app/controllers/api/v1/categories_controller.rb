# frozen_string_literal: true
class Api::V1::CategoriesController < ApplicationController
  def index
    categories = CategoryResource.all(params)
    render(jsonapi: categories)
  end

  def show
    category = CategoryResource.find(params)
    render(jsonapi: category)
  end

  def create
    category = CategoryResource.build(params)

    if category.save
      render(jsonapi: category, status: 201)
    else
      render(jsonapi_errors: category)
    end
  end

  def update
    category = CategoryResource.find(params)

    if category.update_attributes
      render(jsonapi: category)
    else
      render(jsonapi_errors: category)
    end
  end

  def destroy
    category = CategoryResource.find(params)

    if category.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: category)
    end
  end
end
