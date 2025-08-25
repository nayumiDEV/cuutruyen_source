# frozen_string_literal: true
class Api::V1::ChapterListingsController < ApplicationController
  def show
    chapter_listing = ChapterListingResource.find(params)
    render(jsonapi: chapter_listing)
  end
end
