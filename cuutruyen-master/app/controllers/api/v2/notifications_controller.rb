class Api::V2::NotificationsController < Api::V2::BaseController
  def index
    authorize Notification, :index?
    @unread_notifications = current_user.notifications.unread.order(created_at: :desc)
    @read_notifications = current_user.notifications.read.order(created_at: :desc)
  end

  def mark_as_read
    authorize Notification, :index?
    @notification = current_user.notifications.find params[:id]
    @notification.touch :read_at

    render status: :accepted
  end

  def mark_all_as_read
    authorize Notification, :index?
    current_user.notifications.unread.update_all read_at: Time.now
    head :accepted
  end

  def unread_count
    authorize Notification, :index?
    total = current_user.notifications.unread.size

    render json: { data: total }
  end
end
