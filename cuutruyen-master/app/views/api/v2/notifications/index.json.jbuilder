json.data do
  json.unread do
    json.partial! 'api/v2/notifications/notification', collection: @unread_notifications, as: :notification
  end

  json.read do
    json.partial! 'api/v2/notifications/notification', collection: @read_notifications, as: :notification
  end
end
