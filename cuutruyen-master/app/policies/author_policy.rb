# frozen_string_literal: true

class AuthorPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.teams.present? ||
      user&.admin?
  end

  def update?
    !user.teams.empty? ||
      user&.admin?
  end

  def destroy?
    !user.teams.empty? ||
      user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
