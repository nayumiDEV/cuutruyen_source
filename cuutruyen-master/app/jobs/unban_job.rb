class UnbanJob < ApplicationJob
  queue_as :unban

  def perform
    UserBan.where('banned_until <= ?', Time.current).find_each do |user_ban|
      user_ban.destroy
    end
  end
end