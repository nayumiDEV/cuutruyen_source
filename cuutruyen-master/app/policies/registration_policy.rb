# frozen_string_literal: true

class RegistrationPolicy < ApplicationPolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def create?
    false if current_user
  end
end
