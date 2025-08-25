# frozen_string_literal: true

class NotificationReadAllResource < ApplicationResource
  self.adapter = Graphiti::Adapters::Null
  self.type = :notification_read_alls
  self.model = User

  def create(attributes)
    current_user&.notifications.unread.update_all read_at: Time.now
    current_user
  end
end
