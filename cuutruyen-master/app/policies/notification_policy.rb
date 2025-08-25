# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def index?
    return false unless user.present?

    true
  end

  def show?
    return false unless user.present?

    if user.admin? || record.recipient == user || user.teams.include?(record.recipient)
      true
    else
      false
    end
  end

  def create?
    false
  end

  def update?
    return false unless user.present?

    if user.admin? || record.recipient == user || user.teams.include?(record.recipient)
      true
    else
      false
    end
  end

  def destroy?
    return false unless user.present?

    if user.admin? || record.recipient == user || user.teams.include?(record.recipient)
      true
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
