class UserBan < ApplicationRecord
  belongs_to :user
  enum ban_type: { mute: 0, ban: 1, shadow_ban: 2 }
end
