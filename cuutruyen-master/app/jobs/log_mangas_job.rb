class LogMangasJob < ApplicationJob
  queue_as :log

  def perform
    create_log_records!
    pre_calculate_ranges!
  end

  def create_log_records!
    Manga.find_each do |manga|
      MangaLog.upsert(
        {
          manga_id: manga.id,
          views_count: manga.views_count,
          date: Time.current.to_date
        }
      )
    end
  end

  def pre_calculate_ranges!
    Manga.find_each do |manga|
      latest_log = MangaLog.order(date: :desc).where(manga_id: manga.id).first
      week_ago_log = MangaLog.order(date: :desc).where(manga_id: manga.id).where('date <= ?', 1.week.ago.to_date).first
      month_ago_log = MangaLog.order(date: :desc).where(manga_id: manga.id).where('date <= ?', 1.month.ago.to_date).first

      views_count_week = 0
      views_count_month = 0

      if latest_log.present? && week_ago_log.present?
        views_count_week = latest_log.views_count - week_ago_log.views_count
      end

      if latest_log.present? && month_ago_log.present?
        views_count_month = latest_log.views_count - month_ago_log.views_count
      end

      manga.update_columns views_count_week: views_count_week, views_count_month: views_count_month
    end
  end
end
