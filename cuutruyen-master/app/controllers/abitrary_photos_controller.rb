class AbitraryPhotosController < ApplicationController
  def show
    @abitrary_photo = AbitraryPhoto.find params[:id]

    redirect_to @abitrary_photo.abitrary_photo.url, allow_other_host: true
  end
end
