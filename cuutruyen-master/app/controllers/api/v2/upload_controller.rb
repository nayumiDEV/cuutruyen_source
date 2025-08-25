# frozen_string_literal: true

class Api::V2::UploadController < Api::V2::BaseController
  skip_before_action :current_user

  def image
    rack_response(ImageUploader.upload_response(:cache, request.env))
  end

  def cover
    rack_response(CoverUploader.upload_response(:cache, request.env))
  end

  def panorama
    rack_response(PanoramaUploader.upload_response(:cache, request.env))
  end

  def abitrary_photo
    rack_response(AbitraryPhotoUploader.upload_response(:cache, request.env))
  end

  def avatar
    rack_response(AvatarUploader.upload_response(:cache, request.env))
  end

  private

  def rack_response((status, headers, body))
    self.status = status
    self.headers.merge!(headers)
    self.response_body = body
  end
end
