# frozen_string_literal: true

class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum role: { editor: 0, owner: 1, member: 2 }

  validates :role, presence: true
end
