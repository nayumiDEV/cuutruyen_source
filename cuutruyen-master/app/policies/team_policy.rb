# frozen_string_literal: true

class TeamPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.admin?
  end

  def update?
    user&.teams&.include?(record) || user&.admin?
  end

  def destroy?
    user&.teams&.include?(record) || user&.admin?
  end

  def simple_manage?
    return true if user&.admin?
    return true if user&.teams&.include?(record)
    return false
  end

  def advanced_manage?
    return true if user&.admin?

    if user&.teams&.include?(record)
      member = record.team_members.find_by user: user
      return false unless member
      return true if member.editor? || member.owner?
    end

    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
