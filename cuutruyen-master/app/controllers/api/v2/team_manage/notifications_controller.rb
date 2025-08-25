class Api::V2::TeamManage::NotificationsController < Api::V2::TeamManage::BaseController
  def index
    @unread_notifications = current_team.notifications.unread.order(created_at: :desc)
    @read_notifications = current_team.notifications.read.order(created_at: :desc)
  end

  def mark_as_read
    @notification = current_team.notifications.find params[:id]
    @notification.touch :read_at

    render status: :accepted
  end

  def mark_all_as_read
    current_team.notifications.unread.update_all read_at: Time.now
    head :accepted
  end

  def unread_count
    total = current_team.notifications.unread.size

    render json: { data: total }
  end
end
