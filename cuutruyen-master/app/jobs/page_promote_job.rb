# frozen_string_literal: true

class PagePromoteJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 5.seconds, attempts: 3 do |job, error|
    record_class = job.arguments[1]
    record_id = job.arguments[2]
    record = Object.const_get(record_class).find(record_id)

    record.update_status!(:failed)
    Rails.logger.error error
  end

  discard_on Shrine::AttachmentChanged do |job, error|
    attacher_class = job.arguments[0]
    record_class = job.arguments[1]
    record_id = job.arguments[2]
    name = job.arguments[3]
    file_data = job.arguments[4]

    record = Object.const_get(record_class).find(record_id)
    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)

    if attacher.stored?
      record.update_status!(:processed)
    else
      record.update_status!(:failed)
      Rails.logger.error error
    end
  end

  discard_on ActiveRecord::RecordNotFound

  before_perform do |job|
    record_class = job.arguments[1]
    record_id = job.arguments[2]
    record = Object.const_get(record_class).find(record_id)

    record.update_status!(:processing)
  end

  after_perform do |job|
    record_class = job.arguments[1]
    record_id = job.arguments[2]
    record = Object.const_get(record_class).find(record_id)

    record.update_status!(:processed)
  end

  def perform(attacher_class, record_class, record_id, name, file_data)
    attacher_class = Object.const_get(attacher_class)
    record = Object.const_get(record_class).find(record_id)

    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
    attacher.atomic_promote

    sleep(2) unless Rails.env.production?
  end
end
