# frozen_string_literal: true

class UserFollowMangaPolicy < ApplicationPolicy
  def index?
    if record.user == user
      true
    else
      false
    end
  end

  def show?
    if record.user == user
      true
    else
      false
    end
  end

  def create?
    if user.present?
      true
    else
      false
    end
  end

  def update?
    false
  end

  def destroy?
    if record.user == user
      true
    else
      false
    end
  end
end
