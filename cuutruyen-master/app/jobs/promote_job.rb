# frozen_string_literal: true

class PromoteJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3
  discard_on Shrine::AttachmentChanged
  discard_on ActiveRecord::RecordNotFound

  before_perform do |job|
    record_class = job.arguments[1]
    record_id = job.arguments[2]

    record = Object.const_get(record_class).find(record_id)
    record.update status: :processing if record.respond_to?(:status=)
  end

  def perform(attacher_class, record_class, record_id, name, file_data)
    attacher_class = Object.const_get(attacher_class)
    record = Object.const_get(record_class).find(record_id)

    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
    attacher.atomic_promote

    record.update status: :processed if record.respond_to?(:status=)
  end
end
