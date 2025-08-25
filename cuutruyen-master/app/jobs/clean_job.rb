class CleanJob < ApplicationJob
  queue_as :clean

  def perform
    clean_cache!
    clean_read_notifications!
  end

  private

  def clean_cache!
    s3 = Shrine.storages[:cache]
    s3.clear! { |object| object.last_modified < 3.days.ago }
  end

  def clean_read_notifications!
    Notification.where('read_at < ?', 1.day.ago).destroy_all
    Notification.where('created_at < ?', 1.month.ago).destroy_all
  end
end
