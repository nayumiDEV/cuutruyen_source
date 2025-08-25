# frozen_string_literal: true

class PagePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def show_sensitive?
    user&.teams&.include?(record.chapter.translation.team) ||
      user&.admin?
  end

  def create?
    page_team_owner = record&.chapter&.translation&.team
    if user&.admin?
      true
    elsif user&.teams&.include?(page_team_owner)
      true
    else
      false
    end
  end

  def update?
    user&.teams&.include?(record.chapter.translation.team) ||
      user&.admin?
  end

  def destroy?
    user&.teams&.include?(record.chapter.translation.team) ||
      user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
