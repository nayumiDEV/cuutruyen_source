# frozen_string_literal: true
class Api::V1::ChaptersController < ApplicationController
  def index
    chapters = ChapterResource.all(params)
    render(jsonapi: chapters)
  end

  def increment
    # chapter = Chapter.find(params[:id])

    # views_counter = ViewsCounter.new
    # views_counter.increment chapter

    render(json: { status: 'success' })
  end

  def show
    chapter = ChapterResource.find(params)
    render(jsonapi: chapter)
  end

  def create
    chapter = ChapterResource.build(params)

    if chapter.save
      render(jsonapi: chapter, status: 201)
    else
      render(jsonapi_errors: chapter)
    end
  end

  def update
    chapter = ChapterResource.find(params)

    if chapter.update_attributes
      render(jsonapi: chapter)
    else
      render(jsonapi_errors: chapter)
    end
  end

  def destroy
    chapter = ChapterResource.find(params)

    if chapter.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: chapter)
    end
  end
end
