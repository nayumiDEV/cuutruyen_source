# frozen_string_literal: true

class TranslationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def show_sensitive?
    user&.translations&.include?(record) ||
      user&.admin?
  end

  def create?
    allowed_teams = user&.teams
    allowed_teams.include?(record&.team) ||
      user&.admin?
  end

  def update?
    user&.translations&.include?(record) ||
      user&.admin?
  end

  def destroy?
    user&.translations&.include?(record) ||
      user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
