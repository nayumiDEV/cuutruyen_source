# frozen_string_literal: true

require 'base64'
require "#{Rails.root}/lib/xorob"

class Page < ApplicationRecord
  include ImageUploader::Attachment(:image)

  has_many :comments, dependent: :nullify
  belongs_to :chapter, touch: true

  counter_culture :chapter

  validates :image, presence: true
  validates :order, presence: true

  enum status: { enqueued: 0, processing: 1, processed: 2, failed: 3 }

  def update_status!(to_status)
    ActiveRecord::Base.transaction do
      chapter.lock!
      update!(status: to_status)
      chapter.update_status!
    end
  end

  def update_chapter_status
    chapter.update_status
  end

  def drm_data_dyn
    drm_data_raw_versioned = "#v4|#{drm_data_raw}"
    xored = Xorob::xor_string(drm_data_raw_versioned, (Math::PI * (10**15)).round.to_s)
    Base64.encode64(xored)
  end
end
