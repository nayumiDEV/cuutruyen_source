class ChapterProcessingStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chapter_processing_status_channel_#{params[:chapter_id]}"
    chapter = Chapter.find(params[:chapter_id])
    transmit(status: chapter.status, progress: chapter.progress)
  end
end
