# frozen_string_literal: true
class Api::V1::TranslationsController < ApplicationController
  def index
    translations = TranslationResource.all(params)
    render(jsonapi: translations)
  end

  def show
    translation = TranslationResource.find(params)
    render(jsonapi: translation)
  end

  def create
    translation = TranslationResource.build(params)

    if translation.save
      render(jsonapi: translation, status: 201)
    else
      render(jsonapi_errors: translation)
    end
  end

  def update
    translation = TranslationResource.find(params)

    if translation.update_attributes
      render(jsonapi: translation)
    else
      render(jsonapi_errors: translation)
    end
  end

  def destroy
    translation = TranslationResource.find(params)

    if translation.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: translation)
    end
  end
end
