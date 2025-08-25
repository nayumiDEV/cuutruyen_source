# frozen_string_literal: true
class Api::V1::ReadingsController < ApplicationController
  def show
    chapter = ReadingResource.find(params)
    render(jsonapi: chapter)
  end
end
