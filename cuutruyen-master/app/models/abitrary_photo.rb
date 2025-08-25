class AbitraryPhoto < ApplicationRecord
  include AbitraryPhotoUploader::Attachment(:abitrary_photo)

  validates :abitrary_photo, presence: true
end
