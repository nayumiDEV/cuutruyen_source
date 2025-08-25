class UserFollowManga < ApplicationRecord
  self.table_name = "users_follow_mangas"

  belongs_to :user
  belongs_to :manga
end
