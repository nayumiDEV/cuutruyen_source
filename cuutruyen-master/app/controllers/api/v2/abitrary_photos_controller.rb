class Api::V2::AbitraryPhotosController < Api::V2::BaseController
  def show
    @abitrary_photo = AbitraryPhoto.find params[:id]

    redirect_to @abitrary_photo.abitrary_photo.url, allow_other_host: true
  end

  def create
    @abitrary_photo = AbitraryPhoto.new abitrary_photo_params
    @abitrary_photo.abitrary_photo_attacher.promote_block do
      promote
    end
    @abitrary_photo.save!

    render json: {
             src: abitrary_photo_path(@abitrary_photo.id),
             width: @abitrary_photo.abitrary_photo.width,
             height: @abitrary_photo.abitrary_photo.height
           }
  end

  private

  def abitrary_photo_params
    params.require(:abitrary_photo).permit(:abitrary_photo)
  end
end
