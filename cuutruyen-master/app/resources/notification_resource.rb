# frozen_string_literal: true

class NotificationResource < ApplicationResource
  polymorphic_belongs_to :recipient do
    group_by(:recipient_type) do
      on(:User)
    end
  end

  attribute :recipient_id, :integer, only: [:filterable]
  attribute :recipient_type, :string, only: [:filterable]
  attribute :type, :string, only: [:readable]
  attribute :title, :string, only: [:readable] do
    @object.to_notification.title
  end
  attribute :message, :string, only: [:readable] do
    @object.to_notification.message_plain
  end
  attribute :url, :string, only: [:readable] do
    @object.to_notification.url
  end
  attribute :icon, :string, only: [:readable] do
    @object.to_notification.icon
  end
  attribute :params, :string, only: [:readable]
  attribute :read_at, :datetime
  attribute :created_at, :datetime, only: [:readable, :sortable]

  paginate do |scope|
      scope
  end

  filter :read, :boolean do
    eq do |scope, value|
      if value
        scope.where('read_at IS NOT NULL')
      else
        scope.where('read_at IS NULL')
      end
    end
  end


  def base_scope
    Pundit.policy_scope(current_user, Notification)
  end
end
