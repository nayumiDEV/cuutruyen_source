# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    if user.present? && (user.user_ban.blank? || user.user_ban.shadow_ban?)
      true
    else
      false
    end
  end

  def update?
    if record.user == user || user&.admin?
      true
    else
      false
    end
  end

  def remove?
    if record.user == user || user&.admin? || user&.teams&.include?(record.translation.team)
      true
    else
      false
    end
  end

  def destroy?
    if user&.admin?
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
