# frozen_string_literal: true

class UserFollowMangaResource < ApplicationResource
  primary_endpoint '/users_follow_mangas'
  self.type = 'users_follow_mangas'

  belongs_to :user
  belongs_to :manga

  attribute :user_id, :integer
  attribute :manga_id, :integer

  def base_scope
    Pundit.policy_scope(current_user, UserFollowManga)
  end
end
