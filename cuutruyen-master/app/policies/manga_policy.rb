# frozen_string_literal: true

class MangaPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.teams.empty? ||
      user&.admin?
  end

  def update?
    user&.mangas&.include?(record) ||
      user&.admin?
  end

  def destroy?
    user&.mangas&.include?(record) ||
      user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
