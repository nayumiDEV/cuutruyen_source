class PersistViewsCountJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 1.minutes, attempts: 3

  def perform
    views_counter = ViewsCounter.new
    views_counter.persist_views_count
  end
end
