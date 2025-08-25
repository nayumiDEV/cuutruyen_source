# frozen_string_literal: true

class ChapterPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.teams&.include?(record.translation.team) ||
      user&.admin?
  end

  def update?
    user&.teams&.include?(record.translation.team) ||
      user&.admin?
  end

  def destroy?
    user&.teams&.include?(record.translation.team) ||
      user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
