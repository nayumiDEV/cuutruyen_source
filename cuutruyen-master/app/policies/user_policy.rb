# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def show_sensitive?
    (user == record) || user&.admin?
  end

  def update?
    (user == record) || user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def change_password?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
